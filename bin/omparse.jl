#=
omparse: parse Modelica files and print the number of classes in each, or the syntax error.
An example of OMParser in an executable compiled with JuliaC (`--trim=safe`):

  julia --project=<env with JuliaC> -e 'using JuliaC; JuliaC.main(ARGS)' -- \
    --output-exe omparse --bundle build --trim=safe --experimental \
    --project=<env with OMParser> bin/omparse.jl
  build/bin/omparse MSL_4_1_0.mo
=#
import OMParser
import OMParser.Absyn

function (@main)(args::Vector{String})::Cint
  local status::Cint = 0
  for file::String in args
    try
      local p::Absyn.Program = OMParser.parseFile(file)
      local n::Int = p isa Absyn.PROGRAM ? length(p.classes) : 0
      println(Core.stdout, file, ": ", n, " classes")
    catch err
      if err isa OMParser.ParseError
        showerror(Core.stdout, err)
        println(Core.stdout)
        status = Cint(1)
      else
        rethrow()
      end
    end
  end
  return status
end
