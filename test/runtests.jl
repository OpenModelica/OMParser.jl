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
    @test occursin("bad1.mo", first_error)
    @test occursin("Missing token: SEMICOLON", first_error)

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
    @test occursin("bad2.mo", second_error)
    @test occursin("Missing token: SEMICOLON", second_error)
  end

  #= Tests to see if the parser can handle the MM language.=#
  include("metaModelicaTests.jl")

  #= Warning might be flaky... =#
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
