#=
Tests of `Modelica"..."` and `@Modelica` (Modelica source written in a Julia file) and of
`parseString`'s `firstLine`, which gives their positions the lines of the Julia file.
The tests of the macros depend on the lines they are written on: positions are given relative to
`@__LINE__`.
=#
module ModelicaMacroTests

using Test
import MetaModelica
import OMParser
using OMParser: @Modelica, @Modelica_str

"The fields of a `SourceInfo` (a mutable struct: compared by its fields)."
fields(i::MetaModelica.SourceInfo) = ntuple(k -> getfield(i, k), fieldcount(typeof(i)))

"The message of the `ParseError` that parsing `text` from the line `firstLine` on throws."
function errorMessage(text::String, firstLine::Int)::String
  try
    OMParser.parseString(text, "e.mo"; firstLine = firstLine)
  catch err
    err isa OMParser.ParseError || rethrow()
    return sprint(showerror, err)
  end
  return "no error"
end

"What expanding `ex` in `mod` throws (the macro's own error, without a `LoadError` around it)."
function expansionError(mod::Module, ex::Expr)::Union{Nothing, Exception}
  try
    macroexpand(mod, ex)
  catch err
    return err isa LoadError ? err.error : err
  end
  return nothing
end

"A model of the given name: its text is put together and parsed at each call."
emptyModel(name::String)::OMParser.Absyn.Program = @Modelica "model $name end $name;"

"A program that is a constant of this function."
constantModel()::OMParser.Absyn.Program = @Modelica "model A end A;"

"A program that is a constant of this function, in the string form."
constantText()::OMParser.Absyn.Program = Modelica"model A end A;"

#= The source of the test "Source positions and comments" (runtests.jl). =#
const POSITIONS = "model A \"doc\"\n  Real x; // c\nequation\n  x = 1;\nend A;\n"

@testset "Modelica in Julia files" begin
  #= The lines move, the columns stay (also the column of a start on the text's first line). =#
  @testset "parseString from a line on" begin
    local p::OMParser.Absyn.Program = OMParser.parseString(POSITIONS, "pos.mo"; firstLine = 10)
    local c::OMParser.Absyn.Class = p.classes.head
    @test fields(c.info) == ("pos.mo", true, 10, 1, 14, 6, 0.0)
    @test fields(c.body.classParts.head.contents.head.element.info) == ("pos.mo", true, 11, 3, 11, 9, 0.0)
    @test fields(c.body.classParts.tail.head.contents.head.info) == ("pos.mo", true, 13, 3, 13, 8, 0.0)
    @test repr(OMParser.parseString(POSITIONS, "pos.mo"; firstLine = 1)) == repr(OMParser.parseString(POSITIONS, "pos.mo"))
    @test_throws ArgumentError OMParser.parseString(POSITIONS, "pos.mo"; firstLine = 0)
  end

  @testset "Errors from a line on" begin
    #= The parser: after the first line (with a line in the message), and on it. =#
    @test errorMessage("model X\n  Real x\nequation\n  x = ;\nend X;\n", 40) ==
          "e.mo:41:9: Expected ';' after the element but found 'equation' on line 42\n    Real x\n          ^"
    @test errorMessage("model M Real x = ; end M;", 40) ==
          "e.mo:40:18: Expected an expression but found ';'\n  model M Real x = ; end M;\n                   ^"
    #= The lexer: an operator, an unterminated string on the first line, a comment after it. =#
    @test startswith(errorMessage("model M\n  Boolean b = true && false;\nend M;\n", 40), "e.mo:41:20: Please use 'and'")
    @test startswith(errorMessage("model M \"open", 40), "e.mo:40:9: Unterminated string")
    @test startswith(errorMessage("model M\n  Real x; /* open\nend M;\n", 40), "e.mo:41:11: Unterminated comment")
  end

  @testset "@Modelica" begin
    local line::Int = @__LINE__
    local program::OMParser.Absyn.Program = @Modelica """
      model Decay "doc"
        Real x(start = 1.0);
      equation
        der(x) = -x;
      end Decay;
      """
    local c::OMParser.Absyn.Class = program.classes.head
    @test c.name == "Decay"
    #= The Julia file and its lines; columns from the left margin of the text. =#
    @test fields(c.info) == (@__FILE__, true, line + 2, 1, line + 6, 10, 0.0)
    @test fields(c.body.classParts.head.contents.head.element.info) == (@__FILE__, true, line + 3, 3, line + 3, 22, 0.0)
    local text::String = "model Decay \"doc\"\n  Real x(start = 1.0);\nequation\n  der(x) = -x;\nend Decay;\n"
    @test repr(program) == repr(OMParser.parseString(text, @__FILE__; firstLine = line + 2))

    #= A text of one line is on the line of the call. =#
    local one::OMParser.Absyn.Program = @Modelica "model A end A;"; local oneLine::Int = @__LINE__
    @test fields(one.classes.head.info) == (@__FILE__, true, oneLine, 1, oneLine, 13, 0.0)

    #= Parsed once, when the macro is expanded: each call gives the same object. =#
    @test constantModel() === constantModel()
    @test Base.isexported(OMParser, Symbol("@Modelica")) && Base.isexported(OMParser, Symbol("@Modelica_str"))
  end

  @testset "Interpolation" begin
    local name::String = "Tank"
    local n::Int = 3
    local p::OMParser.Absyn.Program = @Modelica "model $name Real x[$n]; end $name;"; local pLine::Int = @__LINE__
    @test p.classes.head.name == "Tank"
    @test repr(p) == repr(OMParser.parseString("model Tank Real x[3]; end Tank;", @__FILE__; firstLine = pLine))
    #= Parsed when the code runs. =#
    @test emptyModel("A").classes.head.name == "A"
    @test emptyModel("B").classes.head.name == "B"
    @test_throws OMParser.ParseError emptyModel("1x")
    local line::Int = @__LINE__
    local q::OMParser.Absyn.Program = @Modelica """
      model $name
        Real x;
      end $name;
      """
    @test fields(q.classes.head.info) == (@__FILE__, true, line + 2, 1, line + 4, 9, 0.0)
  end

  #= Backslashes as in a Modelica file; a quote escaped in a Modelica string takes two. =#
  @testset "Modelica\"...\"" begin
    local line::Int = @__LINE__
    local p::OMParser.Absyn.Program = Modelica"""
      model W
        parameter String s = "a\tb \\"c\\" $d";
      end W;
      """
    local text::String = "model W\n  parameter String s = \"a\\tb \\\"c\\\" \$d\";\nend W;\n"
    @test repr(p) == repr(OMParser.parseString(text, @__FILE__; firstLine = line + 2))
    @test occursin("a\\tb \\\"c\\\" \$d", text) && occursin(repr("a\\tb \\\"c\\\" \$d"), repr(p))
    #= A text of one line is on the line of the call; parsed once, when the macro is expanded. =#
    local one::OMParser.Absyn.Program = Modelica"model A end A;"; local oneLine::Int = @__LINE__
    @test fields(one.classes.head.info) == (@__FILE__, true, oneLine, 1, oneLine, 13, 0.0)
    @test constantText() === constantText()
    @test expansionError(@__MODULE__, :(Modelica"model X Real x end X;")) isa OMParser.ParseError
  end

  @testset "Errors when the macro is expanded" begin
    local line::Int = @__LINE__
    local bad::Expr = :(@Modelica """
      model X
        Real x
      equation
      end X;
      """)
    local err::Union{Nothing, Exception} = expansionError(@__MODULE__, bad)
    @test err isa OMParser.ParseError
    @test err.fileName == @__FILE__
    @test (err.line, err.column) == (line + 3, 9)
    @test err.message == "Expected ';' after the element but found 'equation' on line $(line + 4)"
    #= Not a string literal. =#
    @test expansionError(@__MODULE__, :(@Modelica text)) isa ArgumentError
    @test expansionError(@__MODULE__, :(@Modelica string("model A end A;"))) isa ArgumentError
  end
end

end
