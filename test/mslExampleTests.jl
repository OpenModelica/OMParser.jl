#=
The example models of the Modelica Standard Library (`msl.mo`: the classes that extend
`Modelica.Icons.Example`) written in a Julia file, with `Modelica"""..."""` and with
`@Modelica """..."""`. The source of each model is cut from the library, written as the literal of
the form, read by Julia's parser and given to the macro: the class that comes out is the class of
the library, positions included. All of them: parsing the 278 models takes 0.03 s.

`msl.mo` has CRLF line ends, and Julia's parser reads every line end of a string literal as a
line feed: the library is read with those line ends.
The license of `msl.mo`: README.md in this directory.
=#
module MSLExampleTests

using Test
import ImmutableList
import MetaModelica
import OMParser
using OMParser: @Modelica, @Modelica_str

const Absyn = OMParser.Absyn

"An example model of the library."
struct ExampleModel
  "The qualified name."
  name::String
  "The class in the tree of the library."
  class::Absyn.Class
  "The line of the library the model starts on."
  firstLine::Int
  "The source of the model (`classText`)."
  text::String
end

"What a form of the macro makes of a model written in it."
@enum Outcome LIBRARY_CLASS OTHER_PROGRAM PARSE_ERROR

"""
    literalLineEnds(text::String)::String

`text` with the line ends of a Julia string literal: Julia's parser reads a carriage return, with
or without a line feed after it, as a line feed.
"""
literalLineEnds(text::String)::String = replace(text, "\r\n" => "\n", "\r" => "\n")

"""
    elementSpecs(class::Absyn.Class)::Vector{Absyn.ElementSpec}

The public and protected elements of a class written with its parts: extends clauses, classes,
components and imports.
"""
function elementSpecs(class::Absyn.Class)::Vector{Absyn.ElementSpec}
  local specs::Vector{Absyn.ElementSpec} = Absyn.ElementSpec[]
  local body::Absyn.ClassDef = class.body
  body isa Absyn.PARTS || return specs
  for part::Absyn.ClassPart in body.classParts
    (part isa Absyn.PUBLIC || part isa Absyn.PROTECTED) || continue
    for item::Absyn.ElementItem in part.contents
      if item isa Absyn.ELEMENTITEM && item.element isa Absyn.ELEMENT
        push!(specs, item.element.specification)
      end
    end
  end
  return specs
end

"""
    isExample(specs::Vector{Absyn.ElementSpec})::Bool

Whether a class with the elements `specs` extends `Modelica.Icons.Example` (`Icons.Example` where
`Modelica.Icons` is imported).
"""
function isExample(specs::Vector{Absyn.ElementSpec})::Bool
  for spec::Absyn.ElementSpec in specs
    if spec isa Absyn.EXTENDS && Absyn.dumpPath(spec.path) in ("Modelica.Icons.Example", "Icons.Example")
      return true
    end
  end
  return false
end

"""
    classText(info::MetaModelica.SourceInfo, lines::Vector{String})::String

The source of the class at `info` in the file of the `lines`: its lines up to its `end` (the end
column of `info` is the column after it), a semicolon after it, and spaces in place of what
precedes the class on its first line. Every line and column of the text is the one of the file.
"""
function classText(info::MetaModelica.SourceInfo, lines::Vector{String})::String
  local text::Vector{String} = lines[info.lineNumberStart:info.lineNumberEnd]
  text[end] = string(first(text[end], info.columnNumberEnd - 1), ";")
  local indent::Int = info.columnNumberStart - 1
  text[1] = string(" "^indent, chop(text[1]; head = indent, tail = 0))
  return join(text, "\n")
end

"""
    collectExamples!(found::Vector{ExampleModel}, class::Absyn.Class, scope::String, lines::Vector{String})::Nothing

Add the example models among `class` (a class of the package `scope`, `""` at the top) and the
classes inside it to `found`. `lines` are the lines of the file.
"""
function collectExamples!(found::Vector{ExampleModel}, class::Absyn.Class, scope::String, lines::Vector{String})::Nothing
  local name::String = isempty(scope) ? class.name : string(scope, ".", class.name)
  local specs::Vector{Absyn.ElementSpec} = elementSpecs(class)
  if isExample(specs)
    local info::MetaModelica.SourceInfo = class.info
    push!(found, ExampleModel(name, class, info.lineNumberStart, classText(info, lines)))
  end
  for spec::Absyn.ElementSpec in specs
    spec isa Absyn.CLASSDEF && collectExamples!(found, spec.class_, name, lines)
  end
  return nothing
end

"""
    exampleModels(file::String)::Vector{ExampleModel}

The example models of the library in `file`, read with the line ends of a Julia string literal.
"""
function exampleModels(file::String)::Vector{ExampleModel}
  local text::String = literalLineEnds(read(file, String))
  local lines::Vector{String} = String.(split(text, '\n'))
  local program::Absyn.Program = OMParser.parseString(text, file)
  local found::Vector{ExampleModel} = ExampleModel[]
  for class::Absyn.Class in program.classes
    collectExamples!(found, class, "", lines)
  end
  return found
end

"""
    stringForm(text::String)::String

`text` as it is written between the quotes of `Modelica\"\"\"...\"\"\"`: as it is, but for
Julia's rule for string macros, in which backslashes before a double quote are escapes. Those
backslashes are doubled: a quote escaped in a Modelica string (backslash, quote) is written with
two backslashes. Three double quotes in a row, which would end the literal, are not in the library.
"""
stringForm(text::String)::String = replace(text, r"(\\+)\"" => s"\1\1\"")

"""
    juliaForm(text::String)::String

`text` as it is written between the quotes of `@Modelica \"\"\"...\"\"\"`, a Julia string: every
backslash doubled, and a backslash before every dollar sign.
"""
juliaForm(text::String)::String = replace(text, "\\" => "\\\\", "\$" => "\\\$")

"""
    stringLiteral(text::String)::String

A call of `Modelica\"\"\"...\"\"\"` as it is written in a Julia file, with `text` on the lines
between the quotes.
"""
stringLiteral(text::String)::String = string("Modelica\"\"\"\n", text, "\n\"\"\"")

"""
    macroLiteral(text::String)::String

A call of `@Modelica \"\"\"...\"\"\"` as it is written in a Julia file, with `text` on the lines
between the quotes.
"""
macroLiteral(text::String)::String = string("@Modelica \"\"\"\n", text, "\n\"\"\"")

"""
    literalCall(literal::String, model::ExampleModel, file::String)::Expr

The macro call Julia's parser reads from `literal` (`stringLiteral`, `macroLiteral`), placed in
`file` on the line before the model's first line: the lines of the text are the lines of the
library.
"""
function literalCall(literal::String, model::ExampleModel, file::String)::Expr
  local call::Expr = Meta.parse(literal)
  call.head === :macrocall || throw(ArgumentError("not a macro call: " * first(literal, 40)))
  call.args[2] = LineNumberNode(model.firstLine - 1, Symbol(file))
  return call
end

"""
    callText(call::Expr)::String

The text Julia's parser gives the macro of `call`.
"""
callText(call::Expr)::String = call.args[3]

"""
    sameTree(a::Any, b::Any)::Bool

Whether `a` and `b` are the same syntax tree: values of the same types with the same fields, the
`SourceInfo`s included (mutable records, which `==` compares by identity). Lists are walked
element by element.
"""
function sameTree(a::Any, b::Any)::Bool
  local T::DataType = typeof(a)
  T === typeof(b) || return false
  if a isa ImmutableList.Cons
    local x::Any = a
    local y::Any = b
    while x isa ImmutableList.Cons && y isa ImmutableList.Cons
      sameTree(x.head, y.head) || return false
      x = x.tail
      y = y.tail
    end
    return typeof(x) === typeof(y)
  elseif isbitstype(T) || a isa String || a isa Symbol
    return a === b
  elseif a isa Array
    size(a) == size(b) || return false
    for i::Int in eachindex(a)
      sameTree(a[i], b[i]) || return false
    end
    return true
  end
  for i::Int in 1:nfields(a)
    sameTree(getfield(a, i), getfield(b, i)) || return false
  end
  return true
end

"""
    outcome(call::Expr, model::ExampleModel)::Outcome

Expand `call`, a `Modelica"..."` or `@Modelica` call of a text without interpolations (the text is
parsed when the macro is expanded, and the expansion is the program, quoted), and compare what
comes out with the model's class in the library.
"""
function outcome(call::Expr, model::ExampleModel)::Outcome
  local expansion::QuoteNode
  try
    expansion = macroexpand(@__MODULE__, call)
  catch err
    (err isa LoadError ? err.error : err) isa OMParser.ParseError || rethrow()
    return PARSE_ERROR
  end
  local program::Absyn.Program = expansion.value
  return length(program.classes) == 1 && sameTree(program.classes.head, model.class) ? LIBRARY_CLASS : OTHER_PROGRAM
end

"""
    libraryCounts(models::Vector{ExampleModel}, rewritten::Vector{String})::Vector{Tuple{String, Int, Int}}

Per library of the Modelica Standard Library (`Modelica.Blocks.Examples.PID_Controller`: `Blocks`),
in alphabetical order: its name, the number of its example models, and the number of those written
as they are in the library (the ones whose names are not among `rewritten`).
"""
function libraryCounts(models::Vector{ExampleModel}, rewritten::Vector{String})::Vector{Tuple{String, Int, Int}}
  local changed::Set{String} = Set{String}(rewritten)
  local total::Dict{String, Int} = Dict{String, Int}()
  local asWritten::Dict{String, Int} = Dict{String, Int}()
  for model::ExampleModel in models
    local library::String = String(split(model.name, '.')[2])
    total[library] = get(total, library, 0) + 1
    asWritten[library] = get(asWritten, library, 0) + (model.name in changed ? 0 : 1)
  end
  return [(library, total[library], asWritten[library]) for library::String in sort!(collect(keys(total)))]
end

@testset "MSL example models in a Julia file" begin
  local file::String = joinpath(@__DIR__, "msl.mo")
  local models::Vector{ExampleModel} = exampleModels(file)
  @test length(models) == 278

  #= The line ends of a literal, also in a Julia file with CRLF line ends. =#
  @test callText(Meta.parse("Modelica\"\"\"\r\nmodel A\r\nend A;\r\n\"\"\"")) == "model A\nend A;\n"

  #= The comparison of the trees: positions count. =#
  local one::ExampleModel = first(models)
  @test sameTree(OMParser.parseString(one.text, file), OMParser.parseString(one.text, file))
  @test !sameTree(OMParser.parseString(one.text, file), OMParser.parseString(one.text, file; firstLine = 2))
  @test !sameTree(OMParser.parseString(one.text, file), OMParser.parseString(one.text, "other.mo"))
  @test !sameTree(one.class, models[2].class)

  #=
  Written by the rules of the form, every model is the class of the library, in both forms.
  Pasted as it is in the library, a model with quotes escaped in its strings (the HTML of the
  documentation) loses their backslashes to Julia: a ParseError when the macro is expanded, in
  both forms. The other models are written as they are.
  =#
  local textChanged::Vector{String} = String[]
  local stringFailures::Vector{String} = String[]
  local macroFailures::Vector{String} = String[]
  local rewritten::Vector{String} = String[]
  local pastedFailures::Vector{String} = String[]
  for model::ExampleModel in models
    local stringCall::Expr = literalCall(stringLiteral(stringForm(model.text)), model, file)
    local macroCall::Expr = literalCall(macroLiteral(juliaForm(model.text)), model, file)
    #= The closing quotes are on a line of their own: the text ends with a line feed. =#
    local text::String = string(model.text, "\n")
    (callText(stringCall) == text && callText(macroCall) == text) || push!(textChanged, model.name)
    outcome(stringCall, model) == LIBRARY_CLASS || push!(stringFailures, model.name)
    outcome(macroCall, model) == LIBRARY_CLASS || push!(macroFailures, model.name)
    if stringForm(model.text) != model.text || juliaForm(model.text) != model.text
      push!(rewritten, model.name)
      local pastedString::Outcome = outcome(literalCall(stringLiteral(model.text), model, file), model)
      local pastedMacro::Outcome = outcome(literalCall(macroLiteral(model.text), model, file), model)
      (pastedString == PARSE_ERROR && pastedMacro == PARSE_ERROR) || push!(pastedFailures, model.name)
    end
  end
  @test textChanged == String[]
  @test stringFailures == String[]
  @test macroFailures == String[]
  @test length(rewritten) == 101
  @test pastedFailures == String[]

  #= The table of README.md: per library, the example models and those written as they are. =#
  @test libraryCounts(models, rewritten) ==
        [("Blocks", 12, 0), ("ComplexBlocks", 1, 1), ("Electrical", 97, 82), ("Fluid", 23, 6),
         ("Magnetic", 19, 3), ("Math", 1, 1), ("Mechanics", 65, 34), ("Media", 41, 39),
         ("StateGraph", 7, 4), ("Thermal", 11, 7), ("Utilities", 1, 0)]
end

end
