#=
List the calls of the parser's own methods (`OMParser.Parser`) that are dispatched at run time: calls the compiler
could not resolve to one method from the inferred argument types. Each one costs a dynamic dispatch
per call, compiles a new specialization per combination of argument types on first use (the first
parse of a large file), and blocks `juliac --trim=safe`.

  include("test/dispatchCheck.jl"); dynamicCalls()
=#

import OMParser

"""
    dynamicCalls(mod::Module = OMParser.Parser)::Vector{Tuple{Method, String}}

For every method defined in `mod` whose signature has concrete argument types, the `:call`
expressions left after inference (dynamic dispatch), as `(method, call)` pairs.
"""
function dynamicCalls(mod::Module = OMParser.Parser)::Vector{Tuple{Method, String}}
  local found::Vector{Tuple{Method, String}} = Tuple{Method, String}[]
  for name::Symbol in names(mod; all = true)
    isdefined(mod, name) || continue
    local f::Any = getfield(mod, name)
    f isa Function || continue
    parentmodule(f) === mod || continue
    for m::Method in methods(f)
      m.module === mod || continue
      local sig::Any = m.sig
      sig isa DataType || continue
      local argTypes::Vector{Any} = collect(sig.parameters[2:end])
      all(t -> t isa Type && (isconcretetype(t) || t isa Union || t === Type), argTypes) || continue
      local typed::Vector{Any} = try
        Base.code_typed_by_type(sig; optimize = true)
      catch
        continue
      end
      for (ci, _) in typed
        for stmt in ci.code
          stmt isa Expr && stmt.head === :call || continue
          local callee::Any = stmt.args[1]
          if callee isa GlobalRef
            callee = isdefined(callee.mod, callee.name) ? getfield(callee.mod, callee.name) : nothing
          elseif callee isa QuoteNode
            callee = callee.value
          end
          #= Builtins and intrinsics are not dispatched, except splatting (`_apply_iterate`). =#
          (callee isa Core.Builtin || callee isa Core.IntrinsicFunction) && callee !== Core._apply_iterate && continue
          push!(found, (m, sprint(show, stmt)))
        end
      end
    end
  end
  return found
end
