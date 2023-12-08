######## FANNO FLOW ########

"""
    FLStarOverD(M::MachNumber,FannoFlow[;gas=Air])

Compute the friction factor times distance to sonic point, divided by diameter, for the
given Mach number `M`, using the equation

``\\dfrac{fL^*}{D} = \\dfrac{1-M^2}{\\gamma M^2} + \\dfrac{\\gamma+1}{2\\gamma} \\ln \\left(\\dfrac{(\\gamma+1)M^2}{2+(\\gamma-1)M^2}\\right)``
"""
function FLStarOverD(M::MachNumber,::Type{FannoFlow};gas::PerfectGas=DefaultPerfectGas)
  γ = SpecificHeatRatio(gas)
  return FLOverD((1-M^2)/(γ*M^2) + (γ+1)/(2γ)*log((γ+1)*M^2/(2+(γ-1)*M^2)))
end

"""
    SubsonicMachNumber(fL_over_D::FLOverD,FannoFlow[;gas=Air]) -> MachNumber

Compute the subsonic Mach number, given the ratio friction factor times distance to sonic point, divided by diameter, `fL_over_D`,
by solving the equation

``\\dfrac{fL^*}{D} = \\dfrac{1-M^2}{\\gamma M^2} + \\dfrac{\\gamma+1}{2\\gamma} \\ln \\left(\\dfrac{(\\gamma+1)M^2}{2+(\\gamma-1)M^2}\\right)``
"""
function SubsonicMachNumber(fL_over_D::FLOverD,::Type{FannoFlow};gas::PerfectGas=DefaultPerfectGas)
  value(fL_over_D) >= 0.0 || error("fL*/D must be positive")
  MachNumber(_subsonic_mach_number_fanno(fL_over_D,gas))
end

"""
    SupersonicMachNumber(fL_over_D::FLOverD,FannoFlow[;gas=Air]) -> MachNumber

Compute the supersonic Mach number, given the ratio friction factor times distance to sonic point, divided by diameter, `fL_over_D`,
by solving the equation

``\\dfrac{fL^*}{D} = \\dfrac{1-M^2}{\\gamma M^2} + \\dfrac{\\gamma+1}{2\\gamma} \\ln \\left(\\dfrac{(\\gamma+1)M^2}{2+(\\gamma-1)M^2}\\right)``
"""
function SupersonicMachNumber(fL_over_D::FLOverD,::Type{FannoFlow};gas::PerfectGas=DefaultPerfectGas)
  max_fLD = FLStarOverD(MachNumber(1e10),FannoFlow,gas=gas)
  value(fL_over_D) >= 0.0 || error("fL*/D must be positive")
  value(fL_over_D) > value(max_fLD) ? MachNumber(NaN) : MachNumber(_supersonic_mach_number_fanno(fL_over_D,gas))
end

"""
    MachNumber(fL_over_D::FLOverD,FannoFlow[;gas=Air]) -> MachNumber, MachNumber

Compute the subsonic and supersonic Mach numbers, given the ratio friction factor times distance to sonic point, divided by diameter, `fL_over_D`,
by solving the equation

``\\dfrac{fL^*}{D} = \\dfrac{1-M^2}{\\gamma M^2} + \\dfrac{\\gamma+1}{2\\gamma} \\ln \\left(\\dfrac{(\\gamma+1)M^2}{2+(\\gamma-1)M^2}\\right)``
"""
function MachNumber(fL_over_D::FLOverD,::Type{FannoFlow};gas::PerfectGas=DefaultPerfectGas)
    SubsonicMachNumber(fL_over_D,FannoFlow,gas=gas), SupersonicMachNumber(fL_over_D,FannoFlow,gas=gas)
end

_subsonic_mach_number_fanno(fL_over_D::FLOverD,gas::PerfectGas) =
      find_zero(x -> FLStarOverD(MachNumber(x),FannoFlow,gas=gas)-fL_over_D,(0.001,1),order=16)

_supersonic_mach_number_fanno(fL_over_D::FLOverD,gas::PerfectGas) =
      find_zero(x -> FLStarOverD(MachNumber(x),FannoFlow,gas=gas)-fL_over_D,(1,1e10),order=16)



FLOverD(f::FrictionFactor,L::Length,D::Diameter) = FLOverD(f*L/D)
Length(fLoverD::FLOverD,D::Diameter,f::FrictionFactor) = Length(fLoverD*D/f)


"""
    POverPStar(M::MachNumber,FannoFlow[;gas=PerfectGas]) -> PressureRatio

Compute the ratio of pressure to the sonic pressure in Fanno flow, given Mach number `M`, from

``\\dfrac{p}{p^*} = \\dfrac{1}{M} \\left(\\dfrac{1+\\gamma}{2+(\\gamma-1)M^2}\\right)^{1/2}``
"""
function POverPStar(M::MachNumber,::Type{FannoFlow};gas::PerfectGas=DefaultPerfectGas)
  γ = SpecificHeatRatio(gas)
  return PressureRatio(1/M*sqrt((1+γ)/(2+(γ-1)*M^2)))
end

"""
    ρOverρStar(M::MachNumber,FannoFlow[;gas=PerfectGas]) -> DensityRatio

Compute the ratio of density to the sonic density in Fanno flow, given Mach number `M`, from

``\\dfrac{\\rho}{\\rho^*} = \\dfrac{1}{M} \\left(\\dfrac{2+(\\gamma-1)M^2}{\\gamma+1}\\right)^{1/2}``
"""
function ρOverρStar(M::MachNumber,::Type{FannoFlow};gas::PerfectGas=DefaultPerfectGas)
  γ = SpecificHeatRatio(gas)
  return DensityRatio(1/M*sqrt((2+(γ-1)*M^2)/(γ+1)))
end

"""
    TOverTStar(M::MachNumber,FannoFlow[;gas=PerfectGas]) -> TemperatureRatio

Compute the ratio of temperature to the sonic temperature in Fanno flow, given Mach number `M`, from

``\\dfrac{T}{T^*} =\\dfrac{\\gamma+1}{2+(\\gamma-1)M^2}``
"""
function TOverTStar(M::MachNumber,::Type{FannoFlow};gas::PerfectGas=DefaultPerfectGas)
  γ = SpecificHeatRatio(gas)
  return TemperatureRatio((γ+1)/(2+(γ-1)*M^2))
end

"""
    MachNumber(T_over_Tstar::TemperatureRatio,FannoFlow[;gas=PerfectGas])

Compute the Mach number for a given ratio of temperature to the sonic temperature `T_over_Tstar` in Fanno flow, from
the solution of

``\\dfrac{T}{T^*} = \\dfrac{\\gamma+1}{2+(\\gamma-1)M^2}``
"""
function MachNumber(T_over_Tstar::TemperatureRatio,::Type{FannoFlow};gas::PerfectGas=DefaultPerfectGas)
    M = find_zero(x -> TOverTStar(MachNumber(x),FannoFlow,gas=gas)-T_over_Tstar,(1e-10,1e10),order=16)
    return MachNumber(M)

end

"""
    P0OverP0Star(M::MachNumber,FannoFlow[;gas=PerfectGas]) -> StagnationPressureRatio

Compute the ratio of stagnation pressure to the sonic stagnation pressure in Fanno flow, given Mach number `M`, from

``\\dfrac{p_0}{p_0^*} = \\dfrac{1}{M} \\left(\\dfrac{2+(\\gamma-1)M^2}{\\gamma+1}\\right)^{(\\gamma+1)/2/(\\gamma-1)}``
"""
function P0OverP0Star(M::MachNumber,::Type{FannoFlow};gas::PerfectGas=DefaultPerfectGas)
  γ = SpecificHeatRatio(gas)
  return StagnationPressureRatio(1/M*((2+(γ-1)*M^2)/(γ+1))^((γ+1)/(2(γ-1))))
end

function MachNumber(p0_over_p0star::StagnationPressureRatio,::Type{FannoFlow};gas::PerfectGas=DefaultPerfectGas)
    Msub = find_zero(x -> P0OverP0Star(MachNumber(x),FannoFlow,gas=gas)-p0_over_p0star,(0.001,1),order=16)
    max_p0_over_p0star = P0OverP0Star(MachNumber(1e10),FannoFlow,gas=gas)

    if value(p0_over_p0star) > value(max_p0_over_p0star)
        return MachNumber(Msub)
    else
        Msup = find_zero(x -> P0OverP0Star(MachNumber(x),FannoFlow,gas=gas)-p0_over_p0star,(1,1e10),order=16)
        return MachNumber(Msub), MachNumber(Msup)
    end
end
