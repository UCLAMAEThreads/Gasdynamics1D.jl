#=
Thermodynamic relationships
=#


####### BASIC PERFECT GAS EQUATIONS OF STATE #######

"""
    Temperature(ρ::Density,p::Pressure[;gas=Air])

Compute the temperature from the density `ρ` and pressure `p`, using

``T = p/(\\rho R)``

Can also switch the order of the arguments.
"""
Temperature(ρ::Density,p::Pressure;gas::PerfectGas=DefaultPerfectGas) = Temperature(p/(ρ*GasConstant(gas)))
Temperature(p::Pressure,ρ::Density;gas::PerfectGas=DefaultPerfectGas) = Temperature(ρ,p,gas=gas)

"""
    Density(T::Temperature,p::Pressure[;gas=Air])

Compute the density from the temperature `T` and pressure `p`, using

``\\rho = p/(\\rho T)``

Can also switch the order of the arguments.
"""
Density(p::Pressure,T::Temperature;gas::PerfectGas=DefaultPerfectGas) = Density(p/(GasConstant(gas)*T))
Density(T::Temperature,p::Pressure;gas::PerfectGas=DefaultPerfectGas) = Density(p,T,gas=gas)

"""
    Pressure(T::Temperature,ρ::Density[;gas=Air])

Compute the pressure from the temperature `T` and density `ρ`, using

``p = \\rho R T``

Can also switch the order of the arguments.
"""
Pressure(ρ::Density,T::Temperature;gas::PerfectGas=DefaultPerfectGas) = Pressure(ρ*GasConstant(gas)*T)
Pressure(T::Temperature,ρ::Density;gas::PerfectGas=DefaultPerfectGas) = Pressure(ρ,T,gas=gas)

"""
    StagnationTemperature(ρ0::StagnationDensity,p0::StagnationPressure[;gas=Air])

Compute the stagnation temperature from the stagnation density `ρ0` and stagnation pressure `p0`, using

``T_0 = p_0/(\\rho_0 R)``

Can also switch the order of the arguments.
"""
StagnationTemperature(ρ0::StagnationDensity,p0::StagnationPressure;gas::PerfectGas=DefaultPerfectGas) = StagnationTemperature(p0/(ρ0*GasConstant(gas)))
StagnationTemperature(p0::StagnationPressure,ρ0::StagnationDensity;gas::PerfectGas=DefaultPerfectGas) = StagnationTemperature(ρ0,p0,gas=gas)

"""
    StagnationDensity(T0::StagnationTemperature,p0::StagnationPressure[;gas=Air])

Compute the stagnation density from the stagnation temperature `T0` and stagnation pressure `p0`, using

``\\rho_0 = p_0/(\\rho T_0)``

Can also switch the order of the arguments.
"""
StagnationDensity(p0::StagnationPressure,T0::StagnationTemperature;gas::PerfectGas=DefaultPerfectGas) = StagnationDensity(p0/(GasConstant(gas)*T0))
StagnationDensity(T0::StagnationTemperature,p0::StagnationPressure;gas::PerfectGas=DefaultPerfectGas) = StagnationDensity(p0,T0,gas=gas)

"""
    StagnationPressure(T0::StagnationTemperature,ρ0::StagnationDensity[;gas=Air])

Compute the stagnation pressure from the stagnation temperature `T0` and stagnation density `ρ0`, using

``p_0 = \\rho R T_0``

Can also switch the order of the arguments.
"""
StagnationPressure(ρ0::StagnationDensity,T0::StagnationTemperature;gas::PerfectGas=DefaultPerfectGas) = StagnationPressure(ρ0*GasConstant(gas)*T0)
StagnationPressure(T0::StagnationTemperature,ρ0::StagnationDensity;gas::PerfectGas=DefaultPerfectGas) = StagnationPressure(ρ0,T0,gas=gas)


"""
    SoundSpeed(T::Temperature[,γ::SpecificHeatRatio=1.4][,R::GasConstant=287])

Compute the speed of sound of a perfect gas, based on the absolute temperature `T`. The ratio of specific heats `γ` and `R`
can also be supplied, but default to the values for air at standard conditions
(1.4 and 287 J/kg.K, respectively).
"""
SoundSpeed(T::Temperature;gas::PerfectGas=DefaultPerfectGas) = SoundSpeed(sqrt(SpecificHeatRatio(gas)*GasConstant(gas)*T))

Enthalpy(T::Temperature;gas::PerfectGas=DefaultPerfectGas) = Enthalpy(SpecificHeatPressure(gas)*T)
Temperature(h::Enthalpy;gas::PerfectGas=DefaultPerfectGas) = Temperature(h/SpecificHeatPressure(gas))

StagnationEnthalpy(T0::StagnationTemperature;gas::PerfectGas=DefaultPerfectGas) = StagnationEnthalpy(SpecificHeatPressure(gas)*T0)
StagnationTemperature(h0::StagnationEnthalpy;gas::PerfectGas=DefaultPerfectGas) = StagnationTemperature(h0/SpecificHeatPressure(gas))

InternalEnergy(T::Temperature;gas::PerfectGas=DefaultPerfectGas) = InternalEnergy(SpecificHeatVolume(gas)*T)
Temperature(e::InternalEnergy;gas::PerfectGas=DefaultPerfectGas) = Temperature(e/SpecificHeatVolume(gas))

StagnationInternalEnergy(T0::StagnationTemperature;gas::PerfectGas=DefaultPerfectGas) = StagnationInternalEnergy(SpecificHeatVolume(gas)*T0)
StagnationTemperature(e0::StagnationInternalEnergy;gas::PerfectGas=DefaultPerfectGas) = StagnationTemperature(e0/SpecificHeatVolume(gas))

StagnationEnthalpy(h::Enthalpy,u::Velocity) = StagnationEnthalpy(value(h)+0.5*value(u)^2)
Enthalpy(h0::StagnationEnthalpy,u::Velocity) = Enthalpy(value(h0)-0.5*value(u)^2)


# Mach number - velocity relations
Velocity(a::SoundSpeed,M::MachNumber) = Velocity(M*a)
MachNumber(u::Velocity,a::SoundSpeed) = MachNumber(u/a)
SoundSpeed(u::Velocity,M::MachNumber) = SoundSpeed(u/M)

# mass flow rate
MassFlowRate(ρ::Density,u::Velocity,A::Area) = MassFlowRate(ρ*u*A)
