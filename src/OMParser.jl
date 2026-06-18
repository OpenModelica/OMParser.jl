module OMParser

using MetaModelica

import Absyn, ImmutableList
import Glob

"""
The path were the package is located.
"""
const INSTALLATION_DIRECTORY_PATH = normpath(joinpath(@__DIR__, ".."))

"""
Directory containing externally downloaded shared libraries.
"""
const SHARED_DIRECTORY_PATH = joinpath(INSTALLATION_DIRECTORY_PATH, "lib", "ext")

struct ParseError <: Exception
  message::String
end

ParseError() = ParseError("Parsing failed")

function Base.showerror(io::IO, err::ParseError)
  print(io, err.message)
end

function last_parse_error_message()
  ptr = ccall((:OMParser_lastErrorMessage, ensure_installed_lib_path()), Cstring, ())
  ptr == C_NULL && return nothing
  try
    unsafe_string(ptr)
  finally
    ccall((:OMParser_clearLastErrorMessage, ensure_installed_lib_path()), Cvoid, ())
  end
end

function isDerCref(exp::Absyn.Exp)::Bool
  @match exp begin
    Absyn.CALL(Absyn.CREF_IDENT("der",  nil()), Absyn.FUNCTIONARGS(Absyn.CREF(__) <|  nil(),  nil()), nil())  => true
    _ => false
  end
end

function parser_library_basename()
  if Sys.islinux()
    return "libomparse-julia.so"
  elseif Sys.iswindows()
    return "libomparse-julia.dll"
  else
    return "libomparse-julia.dylib"
  end
end

"""
  Find parser libraries built locally or downloaded into a known directory.
"""
function locate_parser_library(base_dir::String)
  isdir(base_dir) || return nothing
  target = parser_library_basename()
  for (root, _, files) in walkdir(base_dir)
    if target in files
      return joinpath(root, target)
    end
  end
  return nothing
end

const _libpath = locate_parser_library(joinpath(INSTALLATION_DIRECTORY_PATH, "lib"))
const libpath = locate_parser_library(joinpath(SHARED_DIRECTORY_PATH, "shared"))
const installedLibPath = something(_libpath, libpath, "")

function ensure_installed_lib_path()
  isempty(installedLibPath) && error(
    "OMParser native library not found. Run `import Pkg; Pkg.build(\"OMParser\")` " *
    "for the active environment, or install a local build under $(joinpath(INSTALLATION_DIRECTORY_PATH, "lib"))."
  )
  installedLibPath
end

"""
langStd:
 ("1.x", 10), ("2.x", 20), ("3.0", 30), ("3.1", 31), ("3.2", 32), ("3.3", 33),
 ("3.4", 34), ("3.5", 35), ("latest",1000), ("experimental", 9999)
 acceptedGram:
 1=Modelica, 2=MetaModelica, 3=ParModelica, 4=Optimica, 5=PdeModelica
"""
function parseString(contents::String,
                     interactiveFileName::String = "<default>",
                     acceptedGram::Int64 = 1,
                     languageStandard::Int64 = 1000)::Absyn.Program
  local res = ccall((:parseString, ensure_installed_lib_path()), Any, (String, String, Int64, Int64), contents, interactiveFileName, acceptedGram, languageStandard)
  if res == nothing
    throw(ParseError(something(last_parse_error_message(), "Parsing failed")))
  end
  res
end

"""
```
parseFile(fileName::String, acceptedGram::Int64 = 1, languageStandard::Int64 = 9999)::Absyn.Program
```

Parse a file according to a grammar and a language standard.

 Language standard mapping for the `languageStandard` argument:
```
 ("1.x", 10), ("2.x", 20), ("3.0", 30), ("3.1", 31), ("3.2", 32), ("3.3", 33),
 ("3.4", 34), ("3.5", 35), ("latest",1000), ("experimental", 9999)
```

Grammar mapping for the `acceptedGram` variable:
```
 1=Modelica, 2=MetaModelica, 3=ParModelica, 4=Optimica, 5=PdeModelica
```
"""
function parseFile(fileName::String, acceptedGram::Int64 = 1, languageStandard::Int64 = 9999)::Absyn.Program
  local res = ccall((:parseFile, ensure_installed_lib_path()), Any, (String, Int64, Int64), fileName, acceptedGram, languageStandard)
  if res == nothing
    throw(ParseError(something(last_parse_error_message(), "Parsing failed")))
  end
  res
end

end
