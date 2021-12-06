module OMParser

import Absyn, MetaModelica, ImmutableList
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

const _libpath = if Sys.iswindows()
  local instDir = INSTALLATION_DIRECTORY_PATH
  joinpath(instDir, "lib", "build", "lib", "x86_64-mingw32", "libomparse-julia.dll")
elseif Sys.islinux()
  local instDir = INSTALLATION_DIRECTORY_PATH
  joinpath(instDir, "lib", "build","lib", "x86_64-linux-gnu", "libomparse-julia.so")
elseif Sys.isapple()
  local instDir = INSTALLATION_DIRECTORY_PATH
  joinpath(instDir, "lib", "build","lib", "x86_64-darwin20.6.0", "libomparse-julia.dylib")
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
