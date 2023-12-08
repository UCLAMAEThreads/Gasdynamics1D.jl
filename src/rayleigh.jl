####### RAYLEIGH FLOW ########


HeatFlux(h01::StagnationEnthalpy,h02::StagnationEnthalpy) = HeatFlux(h02-h01)

"""
    HeatFlux(T01::StagnationTemperature,T02::StagnationTemperature[;gas=Air])

Compute the heat flux required to change stagnation temperature `T01` to stagnation temperature `T02`,
using

``q = c_p(T_{02} - T_{01})``
"""
function HeatFlux(T01::StagnationTemperature,T02::StagnationTemperature;gas::PerfectGas=DefaultPerfectGas)
  h01 = StagnationEnthalpy(T01;gas=gas)
  h02 = StagnationEnthalpy(T02;gas=gas)
  return HeatFlux(h01,h02)
end

# Fanno flow produces StagnationPressureRatio. There should also be a StagnationTemperatureRatio
# defined in ThermofluidQuantities.jl

"""
    T0OverT0Star(M::MachNumber,RayleighFlow[;gas=Air]) -> TemperatureRatio

Compute the ratio of stagnation temperature to sonic stagnation temperature for the given Mach number
for Rayleigh flow, using the equation
  
``\\dfrac{T_0}{T_0^*} = \\dfrac{(\\gamma+1)M^2 (2 + (\\gamma-1)M^2)}{(1+\\gamma M^2)^2}``
"""
function T0OverT0Star(M::MachNumber,::Type{RayleighFlow};gas::PerfectGas=DefaultPerfectGas)
  γ = SpecificHeatRatio(gas)
  return TemperatureRatio(((γ+1)*M^2*(2+(γ-1)*M^2))/(1+γ*M^2)^2)
end

"""
    TOverTStar(M::MachNumber,RayleighFlow[;gas=Air]) -> TemperatureRatio

Compute the ratio of temperature to sonic temperature for the given Mach number
for Rayleigh flow, using the equation
  
``\\dfrac{T}{T^*} = \\dfrac{(\\gamma+1)^2 M^2}{(1+\\gamma M^2)^2}``
"""
function TOverTStar(M::MachNumber,::Type{RayleighFlow};gas::PerfectGas=DefaultPerfectGas)
  γ = SpecificHeatRatio(gas)
  return TemperatureRatio(((γ+1)^2*M^2)/(1+γ*M^2)^2)
end

function MachNumber(T0_over_T0star::TemperatureRatio,::Type{RayleighFlow};gas::PerfectGas=DefaultPerfectGas)
   value(T0_over_T0star) <= 1.0 || error("T0/T0* must be 1 or smaller")

    Msub = find_zero(x -> T0OverT0Star(MachNumber(x),RayleighFlow,gas=gas)-T0_over_T0star,(0.001,1),order=16)
    max_T0ratio = T0OverT0Star(MachNumber(1e10),RayleighFlow,gas=gas)

    if value(T0_over_T0star) < value(max_T0ratio)
        return MachNumber(Msub)
    else
        Msup = find_zero(x -> T0OverT0Star(MachNumber(x),RayleighFlow,gas=gas)-T0_over_T0star,(1,1e10),order=16)
        return MachNumber(Msub), MachNumber(Msup)
    end
end

"""
    POverPStar(M::MachNumber,RayleighFlow[;gas=Air]) -> PressureRatio

Compute the ratio of pressure to sonic pressure for the given Mach number
for Rayleigh flow, using the equation
  
``\\dfrac{p}{p^*} = \\dfrac{\\gamma+1}{1+\\gamma M^2}``
"""
function POverPStar(M::MachNumber,::Type{RayleighFlow};gas::PerfectGas=DefaultPerfectGas)
  γ = SpecificHeatRatio(gas)
  return PressureRatio((γ+1)/(1+γ*M^2))
end

"""
    VOverVStar(M::MachNumber,RayleighFlow[;gas=Air]) -> VelocityRatio

Compute the ratio of velocity to sonic velocity for the given Mach number
for Rayleigh flow, using the equation
  
``\\dfrac{V}{V^*} = \\dfrac{(\\gamma+1)M^2}{1+\\gamma M^2}``
"""
function VOverVStar(M::MachNumber,::Type{RayleighFlow};gas::PerfectGas=DefaultPerfectGas)
  γ = SpecificHeatRatio(gas)
  return VelocityRatio(((γ+1)*M^2)/(1+γ*M^2))
end

"""
    ρOverρStar(M::MachNumber,RayleighFlow[;gas=Air]) -> DensityRatio

Compute the ratio of density to sonic density for the given Mach number
for Rayleigh flow, using the equation
  
``\\dfrac{\\rho}{\\rho^*} = \\dfrac{1+\\gamma M^2}{(\\gamma+1)M^2}``
"""
function ρOverρStar(M::MachNumber,::Type{RayleighFlow};gas::PerfectGas=DefaultPerfectGas)
  return DensityRatio(1/VOverVStar(M,RayleighFlow,gas=gas))
end

"""
    P0OverP0Star(M::MachNumber,RayleighFlow[;gas=Air]) -> PressureRatio

Compute the ratio of stagnation pressure to sonic stagnation pressure for the given Mach number
for Rayleigh flow, using the equation
  
``\\dfrac{p_0}{p_0^*} = \\dfrac{(\\gamma+1)}{1+\\gamma M^2} \\left[ \\left( \\dfrac{1}{\\gamma+1} \\right)\\left(2 + (\\gamma-1) M^2\\right)\\right]^{\\gamma/(\\gamma-1)}``
"""
function P0OverP0Star(M::MachNumber,::Type{RayleighFlow};gas::PerfectGas=DefaultPerfectGas)
  γ = SpecificHeatRatio(gas)
  return PressureRatio((γ+1)/(1+γ*M^2)*((2+(γ-1)*M^2)/(γ+1))^(γ/(γ-1)))
end
