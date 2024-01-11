using Test

import OMParser

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
