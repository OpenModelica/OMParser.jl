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
    OMParser

The Modelica parser of OM.jl, in two modules:
- `OMParser.Absyn`: the abstract syntax (omc's Absyn records);
- `OMParser.Parser`: a lexer (`tokenize`) and a recursive-descent parser with one function per
  grammar rule, written in Julia.

`parseFile` and `parseString` turn Modelica (or MetaModelica, ParModelica, Optimica, PDEModelica)
source into an `Absyn.Program`, the same trees omc's parser builds. Errors are `ParseError`s that
say what was expected where.
"""
module OMParser

public Absyn, Parser, parseFile, parseString, ParseError

include("Absyn/Absyn.jl")
include("Parser/Parser.jl")

using .Parser: parseFile, parseString, ParseError

include("Precompile.jl")

end
