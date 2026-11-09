#=
Deep comparison of two Absyn trees: the same types and the same field values everywhere,
SourceInfo included. Used to check the parser against OMParser 0.2's ANTLR/C parser, loaded from
its library in the same session. The reference builds the records of the Absyn package (Absyn.jl,
which must be in the active environment), the parser those of `OMParser.Absyn`: types are compared
by name.
=#

import ImmutableList
import OMParser

"""
    REFERENCE_LIB

The OMParser 0.2 C library (`libomparse-julia`) the trees are compared against, from
`ENV["OMPARSER_REFERENCE_LIB"]`: the library of the OMParser.jl v0.2.4 release for this Julia
version and platform, or a build of its `lib/parser`. It finds Absyn, ImmutableList and
MetaModelica by UUID and calls `OMParser.isDerCref` (defined below for it), so its trees have the
types of the Absyn package (Absyn.jl, UUID ce2f92e2-a952-11e9-0543-8b443f216f1d), `ReferenceAbsyn`;
`OMParser.Absyn` has the same records.
"""
const REFERENCE_LIB = get(ENV, "OMPARSER_REFERENCE_LIB", "")

# The Absyn package (Absyn.jl) the reference library builds its trees with, found by its UUID as the
# library does. (No docstring: one on a constant bound to a module replaces that module's docs.)
const ReferenceAbsyn = Base.require(Base.PkgId(Base.UUID("ce2f92e2-a952-11e9-0543-8b443f216f1d"), "Absyn"))

"""
    referenceIsDerCref(exp::ReferenceAbsyn.Exp)::Bool

`OMParser.Parser.isDerCref` on the reference's records: `der(cref)`. The reference library calls
`OMParser.isDerCref`, defined below to forward here.
"""
function referenceIsDerCref(exp::ReferenceAbsyn.Exp)::Bool
  exp isa ReferenceAbsyn.CALL || return false
  local fn::ReferenceAbsyn.ComponentRef = exp.function_
  (fn isa ReferenceAbsyn.CREF_IDENT && fn.name == "der" && fn.subscripts isa ImmutableList.Nil) || return false
  exp.typeVars isa ImmutableList.Nil || return false
  local fa::ReferenceAbsyn.FunctionArgs = exp.functionArgs
  fa isa ReferenceAbsyn.FUNCTIONARGS || return false
  fa.argNames isa ImmutableList.Nil || return false
  local args::ImmutableList.List = fa.args
  return args isa ImmutableList.Cons && args.head isa ReferenceAbsyn.CREF && args.tail isa ImmutableList.Nil
end

isdefined(OMParser, :isDerCref) || Core.eval(OMParser, :(isDerCref(exp) = $referenceIsDerCref(exp)))

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
    SAME_TYPE

`sameType` of pairs of concrete types seen so far.
"""
const SAME_TYPE = Dict{Tuple{DataType, DataType}, Bool}()

"""
    sameType(a::DataType, b::DataType)::Bool

`a` and `b` are the same type up to the module that defines the Absyn records: the same name, the
same name of the defining module, both abstract or both with the same field names, and the same
parameters (compared alike).
`Absyn.CALL` (the reference) and `OMParser.Absyn.CALL` are the same; ImmutableList and
MetaModelica types are shared, so they are identical.
"""
function sameType(a::DataType, b::DataType)::Bool
  a === b && return true
  local known::Union{Nothing, Bool} = get(SAME_TYPE, (a, b), nothing)
  known === nothing || return known
  local same::Bool = nameof(a) === nameof(b) && nameof(parentmodule(a)) === nameof(parentmodule(b)) &&
    isabstracttype(a) == isabstracttype(b) && (isabstracttype(a) || fieldnames(a) == fieldnames(b)) &&
    sameParameters(a.parameters, b.parameters)
  SAME_TYPE[(a, b)] = same
  return same
end

"""
    sameParameters(pa::Core.SimpleVector, pb::Core.SimpleVector)::Bool

The type parameters of `sameType`, one by one: types alike, unions member by member, values equal.
"""
function sameParameters(pa::Core.SimpleVector, pb::Core.SimpleVector)::Bool
  length(pa) == length(pb) || return false
  for i::Int in eachindex(pa)
    sameParameter(pa[i], pb[i]) || return false
  end
  return true
end

"""
    sameParameter(p::Any, q::Any)::Bool

One type parameter of `sameParameters`.
"""
function sameParameter(p::Any, q::Any)::Bool
  p === q && return true
  if p isa DataType && q isa DataType
    return sameType(p, q)
  elseif p isa Union && q isa Union
    local up::Vector{Any} = Base.uniontypes(p)
    local uq::Vector{Any} = Base.uniontypes(q)
    length(up) == length(uq) || return false
    for x::Any in up
      local found::Bool = false
      for y::Any in uq
        if sameParameter(x, y)
          found = true
          break
        end
      end
      found || return false
    end
    return true
  elseif p isa UnionAll && q isa UnionAll
    return sameParameter(Base.unwrap_unionall(p), Base.unwrap_unionall(q))
  elseif p isa TypeVar && q isa TypeVar
    return p.name === q.name
  end
  return isequal(p, q)
end

"""
    firstDifference(a, b, path::String = "")::Union{Nothing, String}

The first place where `a` and `b` differ (in type, by `sameType`, or value), as a path from the
root, or `nothing` when they are identical. Lists are walked iteratively (long element lists).
"""
function firstDifference(a, b, path::String = "")::Union{Nothing, String}
  local ta::DataType = typeof(a)
  local tb::DataType = typeof(b)
  sameType(ta, tb) || return path * ": type " * string(ta) * " vs " * string(tb)
  if a isa ImmutableList.Cons
    local i::Int = 1
    local x::Any = a
    local y::Any = b
    while x isa ImmutableList.Cons && y isa ImmutableList.Cons
      local d::Union{Nothing, String} = firstDifference(x.head, y.head, path * "[" * string(i) * "]")
      d === nothing || return d
      x = x.tail
      y = y.tail
      sameType(typeof(x), typeof(y)) || return path * "[tail " * string(i) * "]: type " * string(typeof(x)) * " vs " * string(typeof(y))
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
