######## GAS DEFINITIONS #######

abstract type Gas end

# default values
const DefaultGasConstant = GasConstant(287)
const DefaultSpecificHeatRatio = SpecificHeatRatio(1.4)

SpecificHeatPressure(;γ::SpecificHeatRatio=DefaultSpecificHeatRatio,
                      R::GasConstant=DefaultGasConstant) = SpecificHeatPressure(γ*R/(γ-1))
SpecificHeatVolume(;γ::SpecificHeatRatio=DefaultSpecificHeatRatio,
                    R::GasConstant=DefaultGasConstant) = SpecificHeatVolume(R/(γ-1))



struct PerfectGas <: Gas
    γ :: SpecificHeatRatio
    R :: GasConstant
    cp :: SpecificHeatPressure
    cv :: SpecificHeatVolume
end

function PerfectGas(;γ::SpecificHeatRatio=DefaultSpecificHeatRatio,R::GasConstant=DefaultGasConstant)
    return PerfectGas(γ,R,SpecificHeatPressure(γ=γ,R=R),SpecificHeatVolume(γ=γ,R=R))
end

SpecificHeatRatio(g::PerfectGas) = g.γ
GasConstant(g::PerfectGas) = g.R
SpecificHeatPressure(g::PerfectGas) = g.cp
SpecificHeatVolume(g::PerfectGas) = g.cv

function Base.show(io::IO, m::MIME"text/plain", g::PerfectGas)
    println(io,"Perfect gas with")
    println(io,"   Specific heat ratio = $(value(SpecificHeatRatio(g)))")
    println(io,"   Gas constant = $(value(GasConstant(g)))")
    println(io,"   cp = $(value(SpecificHeatPressure(g)))")
    println(io,"   cv = $(value(SpecificHeatVolume(g)))")
end


const DefaultPerfectGas = PerfectGas()
const Air = PerfectGas()
export Air

# To add a gas, give it a name, the specific heat ratio, and the molar mass
@create_gas He  5//3  4.002602u"g/mol"
@create_gas O2  1.395 31.999u"g/mol"
@create_gas CO2 1.289 44.01u"g/mol"
@create_gas H2  1.405 2.016u"g/mol"
@create_gas N2  1.40  28.0134u"g/mol"
@create_gas Ar  5//3  39.948u"g/mol"
