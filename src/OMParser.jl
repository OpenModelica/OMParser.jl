module OMParser

import Absyn, MetaModelica, ImmutableList
#= For searching files.. =#
import Glob
using MetaModelica

#import Settings
INSTALLATION_DIRECTORY_PATH = realpath(realpath(dirname(Base.find_package("OMParser")) * "/../"))

struct ParseError
end

function isDerCref(exp::Absyn.Exp)::Bool
  @match exp begin
    Absyn.CALL(Absyn.CREF_IDENT("der",  nil()), Absyn.FUNCTIONARGS(Absyn.CREF(__) <|  nil(),  nil()), nil())  => true
    _ => false
  end
end

function locateSharedParserLibrary(directoryToSearchIn)
  local res = Glob.glob("*",  joinpath(directoryToSearchIn, "lib"))
  local results = []
  for p in res
    push!(results, Glob.glob("*",  joinpath(directoryToSearchIn, p)))
  end
  #= Locate DLL =#
  if Sys.islinux()
    for r in results
      for p in r
        if occursin("libomparse-julia.so", p)
          return p
        end
      end
    end
    throw("No so exiting...")
  elseif Sys.iswindows()
    for r in results
      for p in r
        if occursin("libomparse-julia.dll", p)
          return p
        end
      end
    end
    throw("No dll exiting...")
  else #= Assume apple=#
    for r in results
      for p in r
        if occursin("libomparse-julia.dylib", p)
          return p
        end
      end
    end
    throw("No dll exiting...")
  end
end


const _libpath = if Sys.iswindows()
  locateSharedParserLibrary(INSTALLATION_DIRECTORY_PATH)
elseif Sys.islinux()
  locateSharedParserLibrary(INSTALLATION_DIRECTORY_PATH)
elseif Sys.isapple()
  locateSharedParserLibrary(INSTALLATION_DIRECTORY_PATH)
else
  throw("Your system is not supported. Supported Systems are Linux, macOS and Windows.")
end

function parseFile(fileName::String, acceptedGram::Int64 = 1)::Absyn.Program
  @debug _libpath
  @debug fileName
  local res = ccall((:parseFile, _libpath), Any, (String, Int64), fileName, acceptedGram)
  if res == nothing
    throw(ParseError())
  end
  res
end

end
