######## ISENTROPIC RELATIONS #########

"""
    TemperatureRatio(pr::PressureRatio,Isentropic[;gas=Air])

Compute the ratio of temperatures between two points connected isentropically, given the ratio of pressures `pr` between those
two points, using the isentropic relation

``\\dfrac{T_2}{T_1} = \\left(\\dfrac{p_2}{p_1}\\right)^{(\\gamma-1)/\\gamma}``
"""
function TemperatureRatio(pratio::PressureRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    γ = SpecificHeatRatio(gas)
    TemperatureRatio(pratio^((γ-1)/γ))
end

"""
    TemperatureRatio(dr::DensityRatio,Isentropic[;gas=Air])

Compute the ratio of temperatures between two points connected isentropically, given the ratio of densities `dr` between those
two points, using the isentropic relation

``\\dfrac{T_2}{T_1} = \\left(\\dfrac{\\rho_2}{\\rho_1}\\right)^{\\gamma-1}``
"""
function TemperatureRatio(ρratio::DensityRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    γ = SpecificHeatRatio(gas)
    TemperatureRatio(ρratio^(γ-1))
end

"""
    PressureRatio(Tr::TemperatureRatio,Isentropic[;gas=Air])

Compute the ratio of temperatures between two points connected isentropically, given the ratio of densities `dr` between those
two points, using the isentropic relation

``\\dfrac{p_2}{p_1} = \\left(\\dfrac{T_2}{T_1}\\right)^{\\gamma/(\\gamma-1)}``
"""
function PressureRatio(Tratio::TemperatureRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    γ = SpecificHeatRatio(gas)
    PressureRatio(Tratio^(γ/(γ-1)))
end

"""
    PressureRatio(dr::DensityRatio,Isentropic[;gas=Air])

Compute the ratio of pressures between two points connected isentropically, given the ratio of densities `dr` between those
two points, using the isentropic relation

``\\dfrac{p_2}{p_1} = \\left(\\dfrac{\\rho_2}{\\rho_1}\\right)^{\\gamma}``
"""
function PressureRatio(ρratio::DensityRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    γ = SpecificHeatRatio(gas).val
    PressureRatio(ρratio^(γ))
end

"""
        T0OverT(M::MachNumber,Isentropic[;gas=PerfectGas]) -> TemperatureRatio

Compute the ratio of stagnation temperature to temperature for Mach number `M`.

``\\dfrac{T_0}{T} = 1 + \\dfrac{\\gamma-1}{2}M^2``

Can also omit the `Isentropic` argument, `T0OverT(M)`
"""
function T0OverT(M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    γ = SpecificHeatRatio(gas)
    return TemperatureRatio(1+0.5*(γ-1)*M^2)
end

T0OverT(M::MachNumber;gas::PerfectGas=DefaultPerfectGas) = T0OverT(M,Isentropic,gas=gas)

"""
        P0OverP(M::MachNumber,Isentropic[;gas=PerfectGas]) -> PressureRatio

Compute the ratio of stagnation pressure to pressure for Mach number `M`.

``\\dfrac{p_0}{p} = \\left(1 + \\dfrac{\\gamma-1}{2}M^2 \\right)^{\\gamma/(\\gamma-1)}``
"""
function P0OverP(M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    γ = SpecificHeatRatio(gas)
    Tratio = T0OverT(M,Isentropic,gas=gas)
    PressureRatio(Tratio,Isentropic,gas=gas)
end

"""
    DensityRatio(Tr::TemperatureRatio,Isentropic[;gas=Air])

Compute the ratio of densities between two points connected isentropically, given the ratio of temperatures `Tr` between those
two points, using the isentropic relation

``\\dfrac{\\rho_2}{\\rho_1} = \\left(\\dfrac{T_2}{T_1}\\right)^{1/(\\gamma-1)}``
"""
function DensityRatio(Tratio::TemperatureRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    γ = SpecificHeatRatio(gas)
    DensityRatio(Tratio^(1/(γ-1)))
end

"""
    DensityRatio(pr::PressureRatio,Isentropic[;gas=Air])

Compute the ratio of densities between two points connected isentropically, given the ratio of pressures `pr` between those
two points, using the isentropic relation

``\\dfrac{\\rho_2}{\\rho_1} = \\left(\\dfrac{p_2}{p_1}\\right)^{1/\\gamma}``
"""
function DensityRatio(pratio::PressureRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    γ = SpecificHeatRatio(gas)
    DensityRatio(pratio^(1/γ))
end

"""
        ρ0Overρ(M::MachNumber,Isentropic[;gas=PerfectGas]) -> DensityRatio

Compute the ratio of stagnation density to density for Mach number `M`.

``\\dfrac{\\rho_0}{\\rho} = \\left(1 + \\dfrac{\\gamma-1}{2}M^2 \\right)^{1/(\\gamma-1)}``
"""
function ρ0Overρ(M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    γ = SpecificHeatRatio(gas)
    Tratio = T0OverT(M,Isentropic,gas=gas)
    DensityRatio(Tratio,Isentropic,gas=gas)
end

# Temperature relations

"""
    StagnationTemperature(T::Temperature,M::MachNumber,Isentropic[;gas=Air])

Compute the stagnation temperature corresponding to temperature `T` and Mach number `M`, using

``T_0 = T \\left( 1 + \\dfrac{\\gamma-1}{2} M^2\\right)``

Can also omit the `Isentropic` argument, `StagnationTemperature(T,M)`.
"""
function StagnationTemperature(T::Temperature,M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    StagnationTemperature(T*T0OverT(M,Isentropic,gas=gas))
end

StagnationTemperature(T::Temperature,M::MachNumber;gas::PerfectGas=DefaultPerfectGas) = StagnationTemperature(T,M,Isentropic,gas=gas)

"""
    Temperature(T0::StagnationTemperature,M::MachNumber,Isentropic[;gas=Air])

Compute the temperature corresponding to stagnation temperature `T0` and Mach number `M`, using

``T = T_0 \\left( 1 + \\dfrac{\\gamma-1}{2} M^2\\right)^{-1}``

Can also omit the `Isentropic` argument, `Temperature(T0,M)`.
"""
Temperature(T0::StagnationTemperature,M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas) = Temperature(T0/T0OverT(M,gas=gas))

Temperature(T0::StagnationTemperature,M::MachNumber;gas::PerfectGas=DefaultPerfectGas) = Temperature(T0,M,Isentropic,gas=gas)

"""
    MachNumber(T_over_T0::TemperatureRatio,Isentropic[;gas=Air])

Compute the Mach number corresponding to the ratio of temperature to stagnation temperature `T_over_T0`, using

``M = \\left( \\dfrac{2}{\\gamma-1}\\left(\\dfrac{1}{T/T_0} - 1 \\right)\\right)^{1/2}``

Can also omit the `Isentropic` argument, `MachNumber(T_over_T0)`. Can also 
supply the arguments for `T` and `T0` separately, `MachNumber(T,T0)`
"""
function MachNumber(T_over_T0::TemperatureRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    value(T_over_T0) <= 1.0 || error("T/T0 must be 1 or smaller. Maybe you need to supply the inverse?")
    γ = SpecificHeatRatio(gas)
    M2 = ((1.0/T_over_T0)-1)*2/(γ-1)
    MachNumber(sqrt(M2))
end

MachNumber(T_over_T0::TemperatureRatio;gas::PerfectGas=DefaultPerfectGas) = MachNumber(T_over_T0,Isentropic,gas=gas)

MachNumber(T::Temperature,T0::StagnationTemperature,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas) = MachNumber(TemperatureRatio(T/T0),gas=gas)

MachNumber(T::Temperature,T0::StagnationTemperature;gas::PerfectGas=DefaultPerfectGas) = MachNumber(T,T0,Isentropic,gas=gas)

# Pressure relations
"""
    StagnationPressure(p::Pressure,M::MachNumber,Isentropic[;gas=Air])

Compute the stagnation pressure corresponding to pressure `p` and Mach number `M`, using

``p_0 = p \\left( 1 + \\dfrac{\\gamma-1}{2} M^2\\right)^{\\gamma/(\\gamma-1)}``

Can also omit the `Isentropic` argument, `StagnationTemperature(T,M)`.
"""
function StagnationPressure(p::Pressure,M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    StagnationPressure(p*PressureRatio(T0OverT(M,gas=gas),Isentropic,gas=gas))
end

"""
    Pressure(p0::StagnationPressure,M::MachNumber,Isentropic[;gas=Air])

Compute the pressure corresponding to stagnation pressure `p0` and Mach number `M`, using

``p = p_0 \\left( 1 + \\dfrac{\\gamma-1}{2} M^2\\right)^{-\\gamma/(\\gamma-1)}``

Can also omit the `Isentropic` argument, `Temperature(T0,M)`.
"""
function Pressure(p0::StagnationPressure,M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    Pressure(p0/PressureRatio(T0OverT(M,gas=gas),Isentropic,gas=gas))
end

"""
    MachNumber(p_over_p0::PressureRatio,Isentropic[;gas=Air])

Compute the Mach number corresponding to the ratio of pressure to stagnation pressure `p_over_p0`, using

``M = \\left( \\dfrac{2}{\\gamma-1}\\left(\\dfrac{1}{(p/p_0)^{(\\gamma-1)/\\gamma}} - 1 \\right)\\right)^{1/2}``

Can also supply the arguments for `p` and `p0` separately, `MachNumber(p,p0)`
"""
function MachNumber(p_over_p0::PressureRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    value(p_over_p0) <= 1.0 || error("p/p0 must be 1 or smaller. Maybe you need to supply the inverse?")
    γ = SpecificHeatRatio(gas)
    MachNumber(TemperatureRatio(p_over_p0,Isentropic,gas=gas),gas=gas)
end

MachNumber(p::Pressure,p0::StagnationPressure,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas) = MachNumber(PressureRatio(p/p0),Isentropic,gas=gas)

# Density relations
"""
    StagnationDensity(ρ::Density,M::MachNumber,Isentropic[;gas=Air])

Compute the stagnation density corresponding to density `ρ` and Mach number `M`, using

``\\rho_0 = \\rho \\left( 1 + \\dfrac{\\gamma-1}{2} M^2\\right)^{1/(\\gamma-1)}``
"""
function StagnationDensity(ρ::Density,M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    StagnationDensity(ρ*DensityRatio(T0OverT(M,gas=gas),Isentropic,gas=gas))
end

"""
    Density(ρ0::StagnationDensity,M::MachNumber,Isentropic[;gas=Air])

Compute the density corresponding to stagnation density `ρ0` and Mach number `M`, using

``\\rho = \\rho_0 \\left( 1 + \\dfrac{\\gamma-1}{2} M^2\\right)^{-1/(\\gamma-1)}``
"""
function Density(ρ0::StagnationDensity,M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    Density(ρ0/DensityRatio(T0OverT(M,gas=gas),Isentropic,gas=gas))
end

"""
    MachNumber(ρ_over_ρ0::DensityRatio,Isentropic[;gas=Air])

Compute the Mach number corresponding to the ratio of density to stagnation density `ρ_over_ρ0`, using

``M = \\left( \\dfrac{2}{\\gamma-1}\\left(\\dfrac{1}{(\\rho/\\rho_0)^{(\\gamma-1)}} - 1 \\right)\\right)^{1/2}``

Can also supply the arguments for `ρ` and `ρ0` separately, `MachNumber(ρ,ρ0)`
"""
function MachNumber(ρ_over_ρ0::DensityRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    value(ρ_over_ρ0) <= 1.0 || error("ρ/ρ0 must be 1 or smaller. Maybe you need to supply the inverse?")
    γ = SpecificHeatRatio(gas)
    MachNumber(TemperatureRatio(ρ_over_ρ0,Isentropic,gas=gas))
end

MachNumber(ρ::Density,ρ0::StagnationDensity,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas) = MachNumber(DensityRatio(ρ/ρ0),gas=gas)


# Area-Mach number relation
"""
    AOverAStar(M::MachNumber,Isentropic[;gas=Air]) -> AreaRatio

Compute the ratio of local area to the sonic area for the given Mach number `M`, using

``\\dfrac{A}{A^*} = \\dfrac{1}{M} \\left( \\dfrac{2}{\\gamma+1} \\left( 1 + \\dfrac{\\gamma-1}{2}M^2\\right)\\right)^{(\\gamma+1)/2/(\\gamma-1)}``

Can omit the `Isentropic` argument.
"""
function AOverAStar(M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    γ = SpecificHeatRatio(gas)
    return AreaRatio(1/M*(2/(γ+1)*(T0OverT(M,gas=gas)))^(0.5*(γ+1)/(γ-1)))
end
AOverAStar(M::MachNumber;gas::PerfectGas=DefaultPerfectGas) = AOverAStar(M,Isentropic,gas=gas)

"""
    AStar(A::Area,M::MachNumber,Isentropic[;gas=Air]) -> Area

Compute the sonic area for the given area `A` and Mach number `M`, using

``A^* = A M \\left( \\dfrac{2}{\\gamma+1} \\left( 1 + \\dfrac{\\gamma-1}{2}M^2\\right)\\right)^{-(\\gamma+1)/2/(\\gamma-1)}``

Can omit the `Isentropic` argument.
"""
function AStar(A::Area,M::MachNumber,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    return Area(A/AOverAStar(M,gas=gas))
end
AStar(A::Area,M::MachNumber;gas::PerfectGas=DefaultPerfectGas) = AStar(A,M,Isentropic,gas=gas)

"""
    SubsonicMachNumber(A_over_Astar::AreaRatio,Isentropic[;gas=Air]) -> MachNumber

Compute the subsonic Mach number for the given ratio of area to sonic area `A_over_Astar` by solving the equation

``\\dfrac{A}{A^*} = \\dfrac{1}{M} \\left( \\dfrac{2}{\\gamma+1} \\left( 1 + \\dfrac{\\gamma-1}{2}M^2\\right)\\right)^{(\\gamma+1)/2/(\\gamma-1)}``
"""
function SubsonicMachNumber(A_over_Astar::AreaRatio,::Type{Isentropic}; gas::PerfectGas=DefaultPerfectGas)
    value(A_over_Astar) >= 1.0 || error("A/A* must be 1 or larger. Maybe you need to supply the inverse?")
    Msub = find_zero(x -> AOverAStar(MachNumber(x),gas=gas)-A_over_Astar,(0,1),order=16)
    return MachNumber(Msub)
end

"""
    SupersonicMachNumber(A_over_Astar::AreaRatio,Isentropic[;gas=Air]) -> MachNumber

Compute the supersonic Mach number for the given ratio of area to sonic area `A_over_Astar` by solving the equation
    
``\\dfrac{A}{A^*} = \\dfrac{1}{M} \\left( \\dfrac{2}{\\gamma+1} \\left( 1 + \\dfrac{\\gamma-1}{2}M^2\\right)\\right)^{(\\gamma+1)/2/(\\gamma-1)}``
"""
function SupersonicMachNumber(A_over_Astar::AreaRatio,::Type{Isentropic}; gas::PerfectGas=DefaultPerfectGas)
  value(A_over_Astar) >= 1.0 || error("A/A* must be 1 or larger. Maybe you need to supply the inverse?")
  Msup = find_zero(x -> AOverAStar(MachNumber(x),gas=gas)-A_over_Astar,(1,Inf),order=16)
  return MachNumber(Msup)
end

function SubsonicMachNumber(A::Area,Aloc::Area,ploc_over_p0::PressureRatio,::Type{Isentropic}; gas::PerfectGas=DefaultPerfectGas)
    Mloc = MachNumber(ploc_over_p0,Isentropic,gas=gas)
    Astar = AStar(Aloc,Mloc,gas=gas)
    SubsonicMachNumber(A,Astar,Isentropic,gas=gas)
end

function SupersonicMachNumber(A::Area,Aloc::Area,ploc_over_p0::PressureRatio,::Type{Isentropic}; gas::PerfectGas=DefaultPerfectGas)
    Mloc = MachNumber(ploc_over_p0,Isentropic,gas=gas)
    Astar = AStar(Aloc,Mloc,gas=gas)
    SupersonicMachNumber(A,Astar,Isentropic,gas=gas)
end

SubsonicMachNumber(A::Area,Astar::Area, ::Type{Isentropic}; gas::PerfectGas=DefaultPerfectGas) =
    SubsonicMachNumber(AreaRatio(A/Astar),Isentropic,gas=gas)

SupersonicMachNumber(A::Area,Astar::Area, ::Type{Isentropic}; gas::PerfectGas=DefaultPerfectGas) =
    SupersonicMachNumber(AreaRatio(A/Astar),Isentropic,gas=gas)


"""
    MachNumber(A_over_Astar::AreaRatio,Isentropic[;gas=Air]) -> MachNumber, MachNumber

Compute the subsonic and supersonic Mach numbers for the given ratio of area to sonic area `A_over_Astar` by solving the equation
    
``\\dfrac{A}{A^*} = \\dfrac{1}{M} \\left( \\dfrac{2}{\\gamma+1} \\left( 1 + \\dfrac{\\gamma-1}{2}M^2\\right)\\right)^{(\\gamma+1)/2/(\\gamma-1)}``

Can omit the `Isentropic` argument.
"""
function MachNumber(A_over_Astar::AreaRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    return SubsonicMachNumber(A_over_Astar,Isentropic,gas=gas),
           SupersonicMachNumber(A_over_Astar,Isentropic,gas=gas)
end

MachNumber(A_over_Astar::AreaRatio;gas::PerfectGas=DefaultPerfectGas) = MachNumber(A_over_Astar,Isentropic,gas=gas)

"""
    MachNumber(M1::MachNumber,A1::AreaRatio,A2::AreaRatio,Isentropic[;gas=Air]) -> MachNumber, MachNumber

Compute the subsonic and supersonic Mach numbers at location 2 with area `A2`, when location 1 has Mach number `M1`
and area `A1`.
"""
function MachNumber(M1::MachNumber,A1::Area,A2::Area,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
    M2sub, M2sup = MachNumber(AreaRatio(A2/AStar(A1,M1,gas=gas)),gas=gas)
end
MachNumber(M1::MachNumber,A1::Area,A2::Area;gas::PerfectGas=DefaultPerfectGas) = MachNumber(M1,A2,A2,Isentropic,gas=gas)


function SubsonicPOverP0(A::Area,Aloc::Area,ploc_over_p0::PressureRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
  Mloc = MachNumber(ploc_over_p0,Isentropic,gas=gas)
  Astar = AStar(Aloc,Mloc,gas=gas)
  SubsonicPOverP0(A,Astar,Isentropic,gas=gas)
end

function SupersonicPOverP0(A::Area,Aloc::Area,ploc_over_p0::PressureRatio,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
  Mloc = MachNumber(ploc_over_p0,Isentropic,gas=gas)
  Astar = AStar(Aloc,Mloc,gas=gas)
  SupersonicPOverP0(A,Astar,Isentropic,gas=gas)
end

function SubsonicPOverP0(A::Area,Astar::Area,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
  M = SubsonicMachNumber(A,Astar,Isentropic,gas=gas)
  PressureRatio(1/P0OverP(M,Isentropic,gas=gas))
end

function SupersonicPOverP0(A::Area,Astar::Area,::Type{Isentropic};gas::PerfectGas=DefaultPerfectGas)
  M = SupersonicMachNumber(A,Astar,Isentropic,gas=gas)
  PressureRatio(1/P0OverP(M,Isentropic,gas=gas))
end
