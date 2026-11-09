#=
Deep comparison of two Absyn trees: the same types and the same field values everywhere,
SourceInfo included. Used to check the recursive-descent parser against the ANTLR parser.
=#

import ImmutableList

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

Parse `file` with the ANTLR parser (`OMParser.parseFile`) and the recursive-descent parser and
return `(:same, nothing)`, `(:diff, path)`, `(:bothfail, message)`, `(:oldfail, message)` or
`(:newfail, message)`.
"""
function compareParsers(file::String; gram::Int = 1, langStd::Int = 9999)
  local old::Any = nothing
  local new::Any = nothing
  local oldErr::Any = nothing
  local newErr::Any = nothing
  try
    old = OMParser.parseFile(file, gram, langStd)
  catch err
    oldErr = err
  end
  try
    new = OMParser.RD.parse(read(file, String), file, gram, langStd, false)
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

`compareParsers` for a source string (`OMParser.parseString` against `RD.parse` read-only).
"""
function compareStrings(src::String; name::String = "<test>", gram::Int = 1, langStd::Int = 1000)
  local old::Any = nothing
  local new::Any = nothing
  local oldErr::Any = nothing
  local newErr::Any = nothing
  try
    old = OMParser.parseString(src, name, gram, langStd)
  catch err
    oldErr = err
  end
  try
    new = OMParser.RD.parse(src, name, gram, langStd, true)
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
