using Gasdynamics1D

@testset "Gases" begin

  @test typeof(Air) <: PerfectGas
  @test typeof(H2) <: PerfectGas
  @test typeof(O2) <: PerfectGas

  @test value(GasConstant(Air)) == 287u"J/kg/K"
  @test value(SpecificHeatRatio(Air)) == 1.4

  @test isapprox(ustrip(GasConstant(Air),u"ft*lbf/(slug*Ra)"),1716.25,atol=1e-2)

end

@testset "Quantities" begin

  p = Pressure(50)
  @test ustrip(p) == 50
  @test unit(p) == u"Pa"

  T = Temperature(20u"°F")
  @test ustrip(T) ≈ 15989//60
  @test unit(T) == u"K"
  @test ustrip(Temperature(20u"°F"),u"°C") ≈ -20//3

  s1 = Entropy(32)
  s2 = Entropy(45)
  @test ustrip(s1-s2) == -13
  @test unit(s1-s2) == u"J/kg/K"

  h1 = Enthalpy(45)
  a = SoundSpeed(10)
  h2 = Enthalpy(h1 + a^2)
  @test ustrip(h2) == 145
  @test unit(h2) == u"J/kg"

  p = Pressure(80u"kPa")
  ρ = Density(1.2)
  T = Temperature(p/ρ/GasConstant(287))
  @test T == Temperature(p,ρ)

end
