using Test
import OMParser

#= Temporary. Going to add the full version later =#
import Pkg
Pkg.add(Pkg.PackageSpec(url="https://github.com/OpenModelica/Absyn.jl.git", rev="master"))

@testset "Simple standalone modules" begin

@test true == begin
  try
    res = OMParser.parseFile("HelloWorld.mo")
    true
  catch
    false
  end
end
  
@test begin
  try
    res = OMParser.parseFile("Influenza.mo")
    true
  catch
    false
  end
end
  
  @test begin
  try
    res = OMParser.parseFile("Casc12800.mo")
    true
  catch
    false
  end
end

end

@testset "Standard Library" begin
  try
    res = OMParser.parseFile("msl.mo")
    true
  catch
    false
  end
end
