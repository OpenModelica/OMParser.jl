using Test

import OMParser

cd(@__DIR__) do
  @testset "Simple standalone modules" begin
    @test true == begin
      try
        res = OMParser.parseFile("HelloWorld.mo")
        true
      catch err
        @info("Test failed with the following error:")
        @info "Error:" err
        false
      end
    end

    @test true == begin
      try
        res = OMParser.parseFile("Influenza.mo")
        true
      catch err
        @info("Test failed with the following error:")
        @info "Error:" err
        false
      end
    end

    @test true == begin
      try
        res = OMParser.parseFile("Casc12800.mo")
        true
      catch err
        @info("Test failed with the following error:")
        @info "Error:" err
        false
      end
    end

  end

  @testset "Test OMCompiler.jl specific extensions" begin
    @test true == begin
      try
        res = OMParser.parseFile("BreakingPendulum.mo")
        true
      catch err
        @info("Test failed with the following error:")
        @info "Error:" err
        false
      end
    end
  end

  @testset "Syntax error reporting" begin
    function parse_error_message(contents::String, file_name::String)
      try
        OMParser.parseString(contents, file_name)
        return nothing
      catch err
        @test err isa OMParser.ParseError
        return sprint(showerror, err)
      end
    end

    bad_contents = "model X\n  Real x\nequation\n  x = ;\nend X;\n"
    good_contents = "model Good\n  Real x;\nend Good;\n"

    first_error = parse_error_message(bad_contents, "bad1.mo")
    @test first_error !== nothing
    @test startswith(first_error, "bad1.mo:2:9: Expected ';' after the element but found 'equation' on line 3")

    @test true == begin
      try
        OMParser.parseString(good_contents, "good.mo")
        true
      catch err
        @info("Test failed with the following error:")
        @info "Error:" err
        false
      end
    end

    second_error = parse_error_message(bad_contents, "bad2.mo")
    @test second_error !== nothing
    @test startswith(second_error, "bad2.mo:2:9: Expected ';'")
  end

  @testset "Error messages" begin
    function message(contents::String)::String
      try
        OMParser.parseString(contents, "e.mo")
        return "accepted"
      catch err
        err isa OMParser.ParseError || rethrow()
        return sprint(showerror, err)
      end
    end
    @test message("model X\n  Real x;\nequation\n  x = ;\nend X;\n") ==
          "e.mo:4:7: Expected an expression but found ';'\n    x = ;\n        ^"
    @test startswith(message("model X\n  Real x;\nequation\n  x = 1\nend X;\n"),
                     "e.mo:4:8: Expected ';' after the equation but found 'end X' on line 5")
    @test startswith(message("model X\n  Real x;\nend Y;\n"),
                     "e.mo:1:7: The identifier at start and end are different: 'X' and 'Y'")
    @test startswith(message("model X\n  String s = \"abc;\nend X;\n"),
                     "e.mo:2:14: Unterminated string")
    @test startswith(message("model X\n  Real x = 1 && 2;\nend X;\n"),
                     "e.mo:2:14: Please use 'and' for logical and")
    @test startswith(message("model X\n  Real x(start = 1;\nend X;\n"),
                     "e.mo:2:19: Expected ')' at the end of the modification but found ';'")
    @test startswith(message("model X\n  Real x;\nend X"),
                     "e.mo:3:6: Expected ';' after the class definition but found end of file")
    local err = try OMParser.parseFile(joinpath(@__DIR__, "NoSuchFile.mo")); nothing catch e; e end
    @test err isa OMParser.ParseError && err.line == 0
  end

  #= Values from OMParser 0.2's ANTLR parser (the same as omc's). =#
  @testset "Source positions and comments" begin
    #= SOURCEINFO is mutable: compare its fields. =#
    fields(i::OMParser.MetaModelica.SourceInfo) = ntuple(k -> getfield(i, k), fieldcount(typeof(i)))
    local p = OMParser.parseString("model A \"doc\"\n  Real x; // c\nequation\n  x = 1;\nend A;\n", "pos.mo")
    local c = p.classes.head
    @test fields(c.info) == fields(OMParser.MetaModelica.SOURCEINFO("pos.mo", true, 1, 1, 5, 6, 0.0))
    local elements = c.body.classParts.head.contents
    @test fields(elements.head.element.info) == fields(OMParser.MetaModelica.SOURCEINFO("pos.mo", true, 2, 3, 2, 9, 0.0))
    @test elements.tail.head == OMParser.Absyn.LEXER_COMMENT("// c\n")
    local eq = c.body.classParts.tail.head.contents.head
    @test fields(eq.info) == fields(OMParser.MetaModelica.SOURCEINFO("pos.mo", true, 4, 3, 4, 8, 0.0))
  end

  #= Tests to see if the parser can handle the MM language.=#
  include("metaModelicaTests.jl")

  #= Warning might be flaky... =#
  #= Modelica 3.6 selective model extension. =#
  @testset "Break modifiers" begin
    local p = OMParser.parseString("""
      model B
        extends A(break x, break connect(a.p, b.n), y = 2);
        Real z(start = break) = break;
      end B;
    """)
    local parts = p.classes.head.body.classParts.head.contents
    local ext = parts.head.element.specification
    local args = collect(ext.elementArg)
    @test length(args) == 3
    @test args[1] isa OMParser.Absyn.INHERITANCEBREAK
    @test args[1].cnct.connector1.name == "break" && args[1].cnct.connector2.name == "x"
    @test args[2] isa OMParser.Absyn.INHERITANCEBREAK
    @test args[2].cnct.connector1 isa OMParser.Absyn.CREF_QUAL
    @test args[3] isa OMParser.Absyn.MODIFICATION
    local comp = parts.tail.head.element.specification.components.head.component
    @test comp.modification.data.eqMod.exp isa OMParser.Absyn.BREAK
    #= Only extends clauses may break elements. =#
    @test_throws Exception OMParser.parseString("model M A a(break x); end M;")
  end

  @testset "Subscripted expressions and pure()" begin
    local p = OMParser.parseString("""
      model S
        Real y = ({1, 2, 3})[2];
        Real z = pure(f(time));
      end S;
    """)
    local comps = p.classes.head.body.classParts.head.contents
    local y = comps.head.element.specification.components.head.component.modification.data.eqMod.exp
    @test y isa OMParser.Absyn.SUBSCRIPTED_EXP
    @test y.exp isa OMParser.Absyn.ARRAY
    local z = comps.tail.head.element.specification.components.head.component.modification.data.eqMod.exp
    @test z isa OMParser.Absyn.CALL && z.function_.name == "pure"
    #= A tuple can not be subscripted. =#
    @test_throws Exception OMParser.parseString("model M Real y = (1, 2)[1]; end M;")
  end

  @testset "Standard Library" begin
    @test true == begin
      try
        res = OMParser.parseFile("msl.mo")
        true
      catch err
        @info("Test failed with the following error:")
        @info "Error:" err
        false
      end
    end
  end
end
