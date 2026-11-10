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

#=
`Modelica"..."` and `@Modelica`: Modelica source written in a Julia file, as its `Absyn.Program`.
=#

"""
    macroFile(source::LineNumberNode)::String

The file a macro call is written in, for the `SourceInfo`s and the error messages (`"<none>"`
where Julia knows no file).
"""
function macroFile(source::LineNumberNode)::String
  local file::Union{Nothing, Symbol} = source.file
  return file === nothing ? "<none>" : String(file)
end

"""
    textFirstLine(source::LineNumberNode, severalLines::Bool)::Int

The line of the Julia file on which the text of the macro call at `source` starts. Julia gives a
macro the line of its call, not the line of its argument: a text of several lines is taken as a
triple-quoted string opened on the line of the call (its text starts on the next line), a text of
one line as written on the line of the call.
"""
function textFirstLine(source::LineNumberNode, severalLines::Bool)::Int
  return source.line + (severalLines ? 1 : 0)
end

"""
    modelicaProgram(text::String, file::String, firstLine::Int)::Absyn.Program

Parse the text of a `Modelica"..."` or `@Modelica` call: Modelica of the latest standard, with
positions in `file` from the line `firstLine` on. Throws a `ParseError`.
"""
function modelicaProgram(text::String, file::String, firstLine::Int)::Absyn.Program
  return parseString(text, file; firstLine = firstLine)
end

"""
    modelicaLiteral(text::String, source::LineNumberNode)::QuoteNode

The expansion of `Modelica"..."`, and of `@Modelica` for a string literal without interpolations:
the text is parsed now, and the expansion is the program itself, quoted.
"""
function modelicaLiteral(text::String, source::LineNumberNode)::QuoteNode
  return QuoteNode(modelicaProgram(text, macroFile(source), textFirstLine(source, '\n' in text)))
end

"""
    modelicaInterpolated(parts::Vector{Any}, source::LineNumberNode)::Expr

The expansion of `@Modelica` for a string with interpolations: a call that puts the text together
and parses it when the code runs. `parts` are the arguments of Julia's `:string` expression, the
literal pieces of the text and the interpolated expressions (evaluated where the macro is called).
"""
function modelicaInterpolated(parts::Vector{Any}, source::LineNumberNode)::Expr
  local severalLines::Bool = false
  local pieces::Vector{Any} = Any[]
  for part::Any in parts
    severalLines = severalLines || (part isa String && '\n' in part)
    push!(pieces, part isa String ? part : esc(part))
  end
  local text::Expr = Expr(:call, GlobalRef(Base, :string), pieces...)
  return Expr(:call, GlobalRef(@__MODULE__, :modelicaProgram), text, macroFile(source),
              textFirstLine(source, severalLines))
end

"""
    modelicaExpansion(text::Any, source::LineNumberNode)::Union{QuoteNode, Expr}

The expansion of `@Modelica text` called at `source`. `text` is what Julia's parser made of the
argument: a `String` (a literal), a `:string` expression (a literal with interpolations), or
something that is not a string literal, which is an `ArgumentError`.
"""
function modelicaExpansion(text::Any, source::LineNumberNode)::Union{QuoteNode, Expr}
  text isa String && return modelicaLiteral(text, source)
  (text isa Expr && text.head === :string) && return modelicaInterpolated(text.args, source)
  throw(ArgumentError("@Modelica takes a string literal with the Modelica text; " *
                      "a text held in a variable is parsed with OMParser.parseString"))
end

"""
    Modelica"text"
    Modelica\"\"\"text\"\"\"

Modelica source written in a Julia file, as its `Absyn.Program`.

```julia
program = Modelica\"\"\"
  model Decay
    Real x(start = 1.0);
  equation
    der(x) = -x;
  end Decay;
  \"\"\"
```

The text is parsed when the macro is expanded: a syntax error is a `ParseError` when the file is
loaded, and the program is a constant of the code (each evaluation gives the same object, nothing
is parsed when the code runs). The `SourceInfo`s and the error messages name the Julia file and
its lines; columns count from the left margin of the text (Julia removes the indentation of a
triple-quoted string).

The text is taken as written, as in a Modelica file: a dollar sign is a dollar sign and
backslashes stay, so the escapes of a Modelica string (`"one\\ntwo"`) are written as there. The
one exception is Julia's rule for string macros: a backslash before a double quote escapes the
quote, so a quote escaped inside a Modelica string (backslash, quote) is written with two
backslashes.

A text built from values is written with `@Modelica`, which interpolates. A text held in a
variable is parsed with `parseString`.

Julia gives a macro the line of its call, not the line of the text. A text of several lines is
taken to start on the line after the call (a triple-quoted string opened on the line of the
call), a text of one line on the line of the call; written otherwise, the lines are off by the
difference.

The grammar is Modelica of the latest standard (the defaults of `parseString`).
"""
macro Modelica_str(text::String)
  return modelicaLiteral(text, __source__)
end

"""
    @Modelica "text"

`Modelica"..."` with interpolation: a Modelica text built from values.

```julia
tank(name::String, n::Int) = @Modelica "model \$name Real x[\$n]; end \$name;"
```

The text is put together and parsed each time the code runs (a syntax error is a `ParseError`
then), with the positions of `Modelica"..."`: the Julia file and its lines. The interpolated
expressions are evaluated where the macro is called.

The text is a Julia string literal, so Julia's escapes apply before the parser sees it: a
backslash of the Modelica text is written `\\\\`, a dollar sign `\\\$`. A text without
interpolations is parsed when the macro is expanded, as with `Modelica"..."`, which is the form
to write such a text in.

Anything but a string literal is an `ArgumentError` when the macro is expanded: a text held in a
variable is parsed with `parseString`.
"""
macro Modelica(text::Any)
  return modelicaExpansion(text, __source__)
end
