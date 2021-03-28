module Gasdynamics1D

  #=
  Quasi-1d gas dynamics routines
  =#


  import Base:+,*,-,/,^,>,<,>=,<=,==,isapprox

  using Roots
  using Requires
  using Reexport

  @reexport using Unitful
  import Unitful: 𝐋, 𝐌, 𝚯, 𝐓, unit, ustrip

  include("plot_recipes.jl")


  #export default_unit,ThermodynamicUnits,SI,SIOtherUnits,Imperial,OtherUnits,Dimensionless
  #export convert_unit
  #export Kelvin, K, Celsius, C, F, TemperatureUnits
  #export Pascals, Pa, KPa, atm, psi, PressureUnits
  #export KGPerCuM, DensityUnits
  #export JPerKG, KJPerKG, SpecificEnergyUnits, EnthalpyUnits, InternalEnergyUnits,
  #        HeatFluxUnits
  #export MPerSec, VelocityUnits, SoundSpeedUnits
  #export SqM, SqCM,AreaUnits
  #export MachNumberUnits
  #export JPerKGK, KJPerKGK, GasConstantUnits
  #export EntropyUnits
  #export KGPerSec, MassFlowRateUnits
  #export Meters, CM, LengthUnits, DiameterUnits
  #export FrictionFactorUnits, FLOverDUnits

  export default_unit
  export ThermodynamicProcess, Isentropic, NormalShock, FannoFlow, RayleighFlow
  export ThermodynamicQuantity
  export units, value, name
  export DefaultGasConstant, DefaultSpecificHeatRatio
  export Gas, PerfectGas, DefaultPerfectGas
  export Air, He, O2,CO2,H2,N2
  export SubsonicMachNumber,SupersonicMachNumber
  export SubsonicPOverP0,SupersonicPOverP0
  export AreaRatio, FrictionFactor, FLOverD, HeatFlux
  export StagnationPressureRatio, PressureRatio, DensityRatio, TemperatureRatio
  export T0OverT,P0OverP,ρ0Overρ,AOverAStar,AStar
  export FLStarOverD,POverPStar,ρOverρStar,TOverTStar,P0OverP0Star
  export HeatFlux,T0OverT0Star,VOverVStar

  function __init__()

    Unitful.register(Gasdynamics1D)

    @require Plots="91a5bcdd-55d7-5caf-9e0b-520d859cae80" begin

      @reexport using LaTeXStrings

      Plots.default(markerstrokealpha = 0, legend = false,
      dpi = 100, size = (400, 300), grid = false)

    end
  end

  #=
  Define basic thermodynamic quantity type and associated operations
  =#

  abstract type ThermodynamicQuantity{U} end

  """
      units(a::ThermodynamicQuantity)

  Return the units of quantity `a`. Extends `units` operation
  in `Unitful`.
  """
  unit(::ThermodynamicQuantity{U}) where U = unit(U)

  """
      value(a::ThermodynamicQuantity)

  Return the numerical value (with units) of `a`
  """
  value(s::ThermodynamicQuantity) = float(s.val)

  """
      value(a::ThermodynamicQuantity,units::Unitful.Units)

  Return the numerical value of `a`, converted to units `units`.
  The form of `units` must be of `Unitful` form, e.g. `u"Pa"`
  and must be dimensionally compatible with `a`
  """
  value(s::ThermodynamicQuantity,units::Unitful.Units) = uconvert(units,value(s))


  """
      ustrip(a::ThermodynamicQuantity)

  Return the numerical value of `a`, stripped
  of its units.
  """
  ustrip(s::ThermodynamicQuantity) = ustrip(value(s))

  """
      ustrip(a::ThermodynamicQuantity,units::Unitful.Units)

  Return the numerical value of `a`, converted to units `units`, and stripped
  of its units. The form of `units` must be of `Unitful` form, e.g. `u"Pa"`
  and must be dimensionally compatible with `a`.
  """
  ustrip(s::ThermodynamicQuantity,units::Unitful.Units) = ustrip(value(s,units))

  """
      name(a::ThermodynamicQuantity)

  Return the name of `a`.
  """
  name(s::ThermodynamicQuantity) = s.name

  function Base.show(io::IO, m::MIME"text/plain", s::ThermodynamicQuantity{U}) where {U}
      print(io,"$(s.name) = $(float(s.val))")
  end

  ####### OPERATIONS ON ALL TYPES #######

  for op in (:(+),:(-),:(>),:(<),:(>=),:(<=),:(==))
      @eval $op(s1::ThermodynamicQuantity{U1},s2::ThermodynamicQuantity{U2}) where {U1,U2} = $op(s1.val,s2.val)
      @eval $op(s1::ThermodynamicQuantity{U1},s2::U2) where {U1,U2<:Quantity} = $op(s1.val,s2)
      @eval $op(s1::U1,s2::ThermodynamicQuantity{U2}) where {U1<:Quantity,U2} = $op(s1,s2.val)
      @eval $op(s::ThermodynamicQuantity,C::Real) = $op(s.val,C)
      @eval $op(C::Real,s::ThermodynamicQuantity) = $op(C,s.val)
  end

  for op in (:(isapprox),)
      @eval $op(s1::ThermodynamicQuantity{U1},s2::ThermodynamicQuantity{U2};kwargs...) where {U1,U2} = $op(s1.val,s2.val;kwargs...)
      @eval $op(s1::ThermodynamicQuantity{U1},s2::U2;kwargs...) where {U1,U2<:Quantity} = $op(s1.val,s2;kwargs...)
      @eval $op(s1::U1,s2::ThermodynamicQuantity{U2};kwargs...) where {U1<:Quantity,U2} = $op(s1,s2.val;kwargs...)
      @eval $op(s::ThermodynamicQuantity,C::Real;kwargs...) = $op(s.val,C;kwargs...)
      @eval $op(C::Real,s::ThermodynamicQuantity;kwargs...) = $op(C,s.val;kwargs...)
  end

  for op in (:(*),:(/))
      @eval $op(s1::ThermodynamicQuantity,s2::ThermodynamicQuantity) = $op(s1.val,s2.val)
      @eval $op(s1::ThermodynamicQuantity,s2::U) where {U<:Quantity} = $op(s1.val,s2)
      @eval $op(s1::U,s2::ThermodynamicQuantity) where {U<:Quantity} = $op(s1,s2.val)
      @eval $op(s::ThermodynamicQuantity,C::Real) = $op(s.val,C)
      @eval $op(C::Real,s::ThermodynamicQuantity) = $op(C,s.val)
  end

  for op in (:(^),)
      @eval $op(s::ThermodynamicQuantity,C::Real) = $op(s.val,C)
  end

  include("utils.jl")
  include("quantities.jl")
  include("gases.jl")


  ###### THERMODYNAMIC PROCESSES #######

  abstract type ThermodynamicProcess end

  abstract type Isentropic <: ThermodynamicProcess end
  abstract type NormalShock <: ThermodynamicProcess end
  abstract type FannoFlow <: ThermodynamicProcess end
  abstract type RayleighFlow <: ThermodynamicProcess end



  include("thermodynamics.jl")
  include("isentropic.jl")
  include("normalshocks.jl")
  include("fanno.jl")
  include("rayleigh.jl")
  include("nozzle.jl")
  include("vectors.jl")


end
