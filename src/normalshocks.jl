###### NORMAL SHOCK RELATIONS #######

"""
    MachNumber(M1::MachNumber,NormalShock[;gas=Air])

Return the Mach number after a normal shock, given the Mach number `M1` before the shock, using the equation

``M_2^2 = \\dfrac{2 + (\\gamma-1)M_1^2}{2\\gamma M_1^2 - (\\gamma-1)}``
"""
function MachNumber(M1::MachNumber,::Type{NormalShock};gas::PerfectGas=DefaultPerfectGas)
    value(M1) >= 1.0 || error("M1 must be at least 1")
    γ = SpecificHeatRatio(gas)
    M2sq = (1 + 0.5*(γ-1)*M1^2)/(γ*M1^2-0.5*(γ-1))
    return MachNumber(sqrt(M2sq))
end

"""
    TemperatureRatio(M1::MachNumber,NormalShock[;gas=Air])

Return the ratio of temperatures after and before a normal shock, given the Mach number `M1` before the shock, using the equation

``\\dfrac{T_2}{T_1} = 1 + 2\\dfrac{(\\gamma-1)}{(\\gamma+1)^2}\\dfrac{(1+\\gamma M_1^2)(M_1^2-1)}{M_1^2}``
"""
function TemperatureRatio(M1::MachNumber,::Type{NormalShock};gas::PerfectGas=DefaultPerfectGas)
    value(M1) >= 1.0 || error("M1 must be at least 1")
    γ = SpecificHeatRatio(gas)
    return TemperatureRatio(1 + 2*(γ-1)/(γ+1)^2*((1+γ*M1^2)/M1^2)*(M1^2-1))
end

"""
    PressureRatio(M1::MachNumber,NormalShock[;gas=Air])

Return the ratio of pressures after and before a normal shock, given the Mach number `M1` before the shock, using the equation

``\\dfrac{p_2}{p_1} = 1 + 2\\dfrac{\\gamma}{\\gamma+1}(M_1^2-1)``
"""
function PressureRatio(M1::MachNumber,::Type{NormalShock};gas::PerfectGas=DefaultPerfectGas)
    value(M1) >= 1.0 || error("M1 must be at least 1")
    γ = SpecificHeatRatio(gas)
    return PressureRatio(1 + 2*γ/(γ+1)*(M1^2-1))
end

"""
    DensityRatio(M1::MachNumber,NormalShock[;gas=Air])

Return the ratio of densities after and before a normal shock, given the Mach number `M1` before the shock, using the equation

``\\dfrac{\\rho_2}{\\rho_1} = \\dfrac{(\\gamma+1)M_1^2}{2+(\\gamma-1)M_1^2}``
"""
function DensityRatio(M1::MachNumber,::Type{NormalShock};gas::PerfectGas=DefaultPerfectGas)
    value(M1) >= 1.0 || error("M1 must be at least 1")
    γ = SpecificHeatRatio(gas)
    return DensityRatio((γ+1)*M1^2/(2+(γ-1)*M1^2))
end

"""
    StagnationPressureRatio(M1::MachNumber,NormalShock[;gas=Air])

Return the ratio of stagnation pressures after and before a normal shock, given the Mach number `M1` before the shock, using the equation

``\\dfrac{p_{02}}{p_{01}} = \\left(\\dfrac{(\\gamma+1)M_1^2}{2+(\\gamma-1)M_1^2}\\right)^{\\gamma/(\\gamma-1)} \\left(\\dfrac{\\gamma+1}{2\\gamma M_1^2 - (\\gamma-1)}\\right)^{1/(\\gamma-1)}``
"""
function StagnationPressureRatio(M1::MachNumber,::Type{NormalShock};gas::PerfectGas=DefaultPerfectGas)
    value(M1) >= 1.0 || error("M1 must be at least 1")
    M2 = MachNumber(M1,NormalShock,gas=gas)
    pratio = PressureRatio(M1,NormalShock,gas=gas)
    p01_unit = StagnationPressure(Pressure(1),M1,Isentropic,gas=gas)
    p02_unit = StagnationPressure(Pressure(1),M2,Isentropic,gas=gas)
    return StagnationPressureRatio(pratio*p02_unit/p01_unit)
end


"""
    Entropy(s1::Entropy,M1::MachNumber,NormalShock[;gas=Air])

Return the entropy after a normal shock, given the entropy before the shock `s1` and the Mach number before
the shock `M1`, using the equation

``s_2 - s_1 = c_v \\ln \\left(1 + \\dfrac{2\\gamma}{\\gamma+1}(M_1^2-1)\\right) - c_p \\ln \\left( \\dfrac{(\\gamma+1)M_1^2}{2+(\\gamma-1)M_1^2}\\right)``
"""
function Entropy(s1::Entropy,M1::MachNumber,::Type{NormalShock};gas::PerfectGas=DefaultPerfectGas)
    value(M1) >= 1.0 || error("M1 must be at least 1")
    γ = SpecificHeatRatio(gas)
    cv = SpecificHeatVolume(gas)
    ds = cv*(log(1+2*γ/(γ+1)*(M1^2-1)) - γ*log((γ+1)*M1^2/(2+(γ-1)*M1^2)))
    return Entropy(s1+ds)

end
