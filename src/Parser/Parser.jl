#=
This file is part of OpenModelica.
Copyright (c) 1998-2026, Open Source Modelica Consortium (OSMC),
c/o Linköpings universitet, Department of Computer and Information Science,
SE-58183 Linköping, Sweden.

All rights reserved.

THIS PROGRAM IS PROVIDED UNDER THE TERMS OF THE GPL VERSION 3 LICENSE OR
THE OSMC PUBLIC LICENSE (OSMC-PL) VERSION 1.2.
ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES
RECIPIENT'S ACCEPTANCE OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3,
ACCORDING TO RECIPIENTS CHOICE.

The OpenModelica software and the OSMC (Open Source Modelica Consortium)
Public License (OSMC-PL) are obtained from OSMC, either from the above
address, from the URLs: http://www.openmodelica.org or
http://www.ida.liu.se/projects/OpenModelica, and in the OpenModelica
distribution. GNU version 3 is obtained from:
http://www.gnu.org/copyleft/gpl.html.

This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, EXCEPT AS
EXPRESSLY SET FORTH IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE
CONDITIONS OF OSMC-PL.
=#

"""
    OMParser.Parser

The lexer (`tokenize`, Lexer.jl, Tokens.jl) and the recursive-descent parser (Rules.jl, one function
per rule of omc's grammar), with the entry points `parseFile` and `parseString`.
"""
module Parser

import ..Absyn
import ImmutableList
import MetaModelica

public parseFile, parseString, ParseError, tokenize

include("Tokens.jl")
include("Lexer.jl")
include("Rules.jl")

"""
The arguments `languageStandard` and `acceptedGram` of `parseFile` and `parseString`, for their
docstrings.
"""
const ARGUMENTS_TEXT = """
Language standards (`languageStandard`):
```
 ("1.x", 10), ("2.x", 20), ("3.0", 30), ("3.1", 31), ("3.2", 32), ("3.3", 33),
 ("3.4", 34), ("3.5", 35), ("latest", 1000), ("experimental", 9999)
```
Grammars (`acceptedGram`):
```
 1 = Modelica, 2 = MetaModelica, 3 = ParModelica, 4 = Optimica, 5 = PDEModelica
```
"""

"""
    parseString(contents::String, interactiveFileName::String = "<default>",
                acceptedGram::Int64 = 1, languageStandard::Int64 = 1000; firstLine::Int = 1)::Absyn.Program

Parse Modelica source text. `interactiveFileName` is the file name in the `SourceInfo`s and in
error messages, and the classes are marked read-only. The text ends at its first NUL character
(as omc reads it). `firstLine` is the number of the text's first line: 1, or the line the text
starts on in the file it is part of (`Modelica"..."` passes the line of the Julia file), so that the
`SourceInfo`s and the error messages give lines of that file. Throws a `ParseError`.

$(ARGUMENTS_TEXT)
"""
function parseString(contents::String, interactiveFileName::String = "<default>",
                     acceptedGram::Int64 = 1, languageStandard::Int64 = 1000; firstLine::Int = 1)::Absyn.Program
  firstLine >= 1 || throw(ArgumentError("firstLine is a line number, 1 or more: got " * string(firstLine)))
  local nul::Union{Nothing, Int} = findfirst(==(0x00), codeunits(contents))
  local source::String = nul === nothing ? contents : String(codeunits(contents)[1:nul - 1])
  return parseSource(source, interactiveFileName, acceptedGram, languageStandard, true, firstLine)
end

"""
    parseFile(fileName::String, acceptedGram::Int64 = 1, languageStandard::Int64 = 9999)::Absyn.Program

Parse a Modelica file. Throws a `ParseError` (line 0 when the file cannot be read).

$(ARGUMENTS_TEXT)
"""
function parseFile(fileName::String, acceptedGram::Int64 = 1, languageStandard::Int64 = 9999)::Absyn.Program
  local source::String = ""
  try
    source = read(fileName, String)
  catch err
    err isa SystemError || rethrow()
    throw(ParseError(fileName, 0, 0, "cannot read the file: " * Libc.strerror(err.errnum), ""))
  end
  return parseSource(source, fileName, acceptedGram, languageStandard, false, 1)
end

end
