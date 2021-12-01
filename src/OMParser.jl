module OMParser

import Absyn, MetaModelica, ImmutableList
using MetaModelica

#import Settings
INSTALLATION_DIRECTORY_PATH = realpath(realpath(Base.find_package("OMParser") * "./../.."))

struct ParseError end

function isDerCref(exp::Absyn.Exp)::Bool
  @match exp begin
    Absyn.CALL(Absyn.CREF_IDENT("der",  nil()), Absyn.FUNCTIONARGS(Absyn.CREF(__) <|  nil(),  nil()))  => true
    _ => false
  end
end

const _libpath = if Sys.iswindows()
  local instDir = INSTALLATION_DIRECTORY_PATH
  joinpath(instDir, "lib", "ext", "libomparse-julia.dll")
else
  local instDir = INSTALLATION_DIRECTORY_PATH
  joinpath(instDir, "lib", "ext", "libomparse-julia.so")
end

function parseFile(fileName::String, acceptedGram::Int64 = 1)::Absyn.Program
  local res = ccall((:parseFile, _libpath), Any, (String,Int64), fileName, acceptedGram)
  if res == nothing
    throw(ParseError())
  end
  res
end

end
