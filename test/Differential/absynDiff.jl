#=
Deep comparison of two Absyn trees: the same types and the same field values everywhere,
SourceInfo included. Used to check the parser against OMParser 0.2's ANTLR/C parser, loaded from
its library in the same session.
=#

import ImmutableList
import OMParser

"""
    REFERENCE_LIB

The OMParser 0.2 C library (`libomparse-julia`) the trees are compared against, from
`ENV["OMPARSER_REFERENCE_LIB"]`: the library of the OMParser.jl v0.2.4 release for this Julia
version and platform, or a build of its `lib/parser`. It finds Absyn, ImmutableList and
MetaModelica by UUID and calls `OMParser.isDerCref`, so its trees have the types of the trees
`OMParser.parseFile` builds.
"""
const REFERENCE_LIB = get(ENV, "OMPARSER_REFERENCE_LIB", "")

"""
    referenceError()::String

The reference library's last error message.
"""
function referenceError()::String
  local ptr::Cstring = ccall((:OMParser_lastErrorMessage, REFERENCE_LIB), Cstring, ())
  ptr == C_NULL && return "Parsing failed"
  local message::String = unsafe_string(ptr)
  ccall((:OMParser_clearLastErrorMessage, REFERENCE_LIB), Cvoid, ())
  return message
end

"""
    referenceParseFile(file::String, gram::Int, langStd::Int)

`parseFile` of OMParser 0.2 (readOnly false).
"""
function referenceParseFile(file::String, gram::Int, langStd::Int)
  isempty(REFERENCE_LIB) && error("set OMPARSER_REFERENCE_LIB to an OMParser 0.2 libomparse-julia")
  local res::Any = ccall((:parseFile, REFERENCE_LIB), Any, (String, Int64, Int64), file, gram, langStd)
  res === nothing && error(referenceError())
  return res
end

"""
    referenceParseString(src::String, name::String, gram::Int, langStd::Int)

`parseString` of OMParser 0.2 (readOnly true).
"""
function referenceParseString(src::String, name::String, gram::Int, langStd::Int)
  isempty(REFERENCE_LIB) && error("set OMPARSER_REFERENCE_LIB to an OMParser 0.2 libomparse-julia")
  local res::Any = ccall((:parseString, REFERENCE_LIB), Any, (String, String, Int64, Int64), src, name, gram, langStd)
  res === nothing && error(referenceError())
  return res
end

"""
    firstDifference(a, b, path::String = "")::Union{Nothing, String}

The first place where `a` and `b` differ (in type or value), as a path from the root, or
`nothing` when they are identical. Lists are walked iteratively (long element lists).
"""
function firstDifference(a, b, path::String = "")::Union{Nothing, String}
  local ta::DataType = typeof(a)
  local tb::DataType = typeof(b)
  ta === tb || return path * ": type " * string(ta) * " vs " * string(tb)
  if a isa ImmutableList.Cons
    local i::Int = 1
    local x::Any = a
    local y::Any = b
    while x isa ImmutableList.Cons && y isa ImmutableList.Cons
      local d::Union{Nothing, String} = firstDifference(x.head, y.head, path * "[" * string(i) * "]")
      d === nothing || return d
      x = x.tail
      y = y.tail
      typeof(x) === typeof(y) || return path * "[tail " * string(i) * "]: type " * string(typeof(x)) * " vs " * string(typeof(y))
      i += 1
    end
    return nothing
  elseif a isa String || a isa Number || a isa Bool || a isa Symbol || a isa Nothing || a isa Char
    return isequal(a, b) ? nothing : path * ": " * repr(a) * " vs " * repr(b)
  elseif a isa Tuple
    for i::Int in eachindex(a)
      local d::Union{Nothing, String} = firstDifference(a[i], b[i], path * "(" * string(i) * ")")
      d === nothing || return d
    end
    return nothing
  end
  for i::Int in 1:fieldcount(ta)
    local d::Union{Nothing, String} = firstDifference(getfield(a, i), getfield(b, i), path * "." * string(fieldname(ta, i)))
    d === nothing || return d
  end
  return nothing
end

"""
    compareParsers(file::String; gram::Int = 1, langStd::Int = 9999)

Parse `file` with OMParser 0.2 (`referenceParseFile`) and `OMParser.parseFile` and return `(:same, nothing)`, `(:diff, path)`, `(:bothfail, message)`, `(:oldfail, message)` or
`(:newfail, message)`.
"""
function compareParsers(file::String; gram::Int = 1, langStd::Int = 9999)
  local old::Any = nothing
  local new::Any = nothing
  local oldErr::Any = nothing
  local newErr::Any = nothing
  try
    old = referenceParseFile(file, gram, langStd)
  catch err
    oldErr = err
  end
  try
    new = OMParser.parseFile(file, gram, langStd)
  catch err
    newErr = err
  end
  if oldErr !== nothing && newErr !== nothing
    return (:bothfail, sprint(showerror, newErr))
  elseif oldErr !== nothing
    return (:oldfail, sprint(showerror, oldErr))
  elseif newErr !== nothing
    return (:newfail, sprint(showerror, newErr))
  end
  local d::Union{Nothing, String} = firstDifference(old, new)
  return d === nothing ? (:same, nothing) : (:diff, d)
end

"""
    compareStrings(src::String; name::String = "<test>", gram::Int = 1, langStd::Int = 1000)

`compareParsers` for a source string (`referenceParseString` against `OMParser.parseString`).
"""
function compareStrings(src::String; name::String = "<test>", gram::Int = 1, langStd::Int = 1000)
  local old::Any = nothing
  local new::Any = nothing
  local oldErr::Any = nothing
  local newErr::Any = nothing
  try
    old = referenceParseString(src, name, gram, langStd)
  catch err
    oldErr = err
  end
  try
    new = OMParser.parseString(src, name, gram, langStd)
  catch err
    newErr = err
  end
  if oldErr !== nothing && newErr !== nothing
    return (:bothfail, sprint(showerror, newErr))
  elseif oldErr !== nothing
    return (:oldfail, sprint(showerror, oldErr))
  elseif newErr !== nothing
    return (:newfail, sprint(showerror, newErr))
  end
  local d::Union{Nothing, String} = firstDifference(old, new)
  return d === nothing ? (:same, nothing) : (:diff, d)
end
