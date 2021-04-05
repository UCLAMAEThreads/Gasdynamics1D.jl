module Gasdynamics1D

  #=
  Quasi-1d gas dynamics routines
  =#


  using Roots
  using Requires
  using Reexport

  @reexport using ThermofluidQuantities

  import ThermofluidQuantities: Unitful, Temperature, Density, Pressure, StagnationTemperature, StagnationDensity,
          StagnationPressure, SoundSpeed, Enthalpy, StagnationEnthalpy, InternalEnergy,
          StagnationInternalEnergy, Velocity, MachNumber, MassFlowRate, Entropy,
          HeatFlux, FrictionFactor, Area, FLOverD, AreaRatio, TemperatureRatio,
          PressureRatio, StagnationPressureRatio, DensityRatio, VelocityRatio


  include("plot_recipes.jl")


  export ThermodynamicProcess, Isentropic, NormalShock, FannoFlow, RayleighFlow
  export SubsonicMachNumber,SupersonicMachNumber
  export SubsonicPOverP0,SupersonicPOverP0
  export T0OverT,P0OverP,ρ0Overρ,AOverAStar,AStar
  export FLStarOverD,POverPStar,ρOverρStar,TOverTStar,P0OverP0Star
  export T0OverT0Star,VOverVStar

  function __init__()

    @require Plots="91a5bcdd-55d7-5caf-9e0b-520d859cae80" begin

      @reexport using LaTeXStrings

      Plots.default(markerstrokealpha = 0, legend = false,
      dpi = 100, size = (400, 300), grid = false)

    end
  end


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
