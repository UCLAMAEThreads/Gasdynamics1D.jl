```@meta
EditURL = "<unknown>/literate/0-BasicGasDynamics.jl"
```

# Basic Tools for Quasi-1D Steady Compressible Flow
This notebook demonstrates the basic syntax for some tools for computing
quasi-1d steady compressible flow.

### Set up the module

```@example 0-BasicGasDynamics
using Gasdynamics1D
```

### Setting basic properties and states
We can set thermodynamic properties and states in a straightforward manner.
However, it is important to remember that we have to explicitly define the
type of property or state we are setting. Examples below will show how this works.

#### Units
When we set a thermodynamic quantity, we also need to set its **units**. For every
quantity, we have a few units to choose from. For example:

```@example 0-BasicGasDynamics
PressureUnits
```

Among these, one is designated the default unit (the SI unit of that quantity).
All quantities are converted to this unit for calculation purposes. For example,
for pressure:

```@example 0-BasicGasDynamics
default_unit(PressureUnits)
```

or enthalpy:

```@example 0-BasicGasDynamics
default_unit(EnthalpyUnits)
```

If we do not specify the unit, it is **automatically set to the default unit**:

```@example 0-BasicGasDynamics
Pressure(10000)
```

If we set the pressure in another unit, it will still convert it to the default
unit for us. This ensures that all calculations are carried out in standardized fashion.

```@example 0-BasicGasDynamics
p = Pressure(1,units=atm)
```

However, we can always report the quantity in some desired units with the `value`
function:

```@example 0-BasicGasDynamics
value(p,atm)
```

```@example 0-BasicGasDynamics
value(p,psi)
```

```@example 0-BasicGasDynamics
value(p,KPa)
```

#### Other thermodynamic quantities
We can set most any other thermodynamic quantity in similar fashion:

```@example 0-BasicGasDynamics
T = Temperature(20,units=Celsius)
```

```@example 0-BasicGasDynamics
T0 = StagnationTemperature(20)
```

```@example 0-BasicGasDynamics
MachNumber(2.0)
```

```@example 0-BasicGasDynamics
Enthalpy(50)
```

```@example 0-BasicGasDynamics
Entropy(10)
```

```@example 0-BasicGasDynamics
Area(50,units=SqCM)
```

```@example 0-BasicGasDynamics
Length(5)
```

and others...

#### Gas properties
We can set the properties of the gas that we are analyzing. (Note: It is
assumed that the gas is perfect.)

```@example 0-BasicGasDynamics
SpecificHeatRatio(1.3)
```

```@example 0-BasicGasDynamics
GasConstant(320)
```

and we can define a gas with these values:

```@example 0-BasicGasDynamics
gas = PerfectGas(γ=SpecificHeatRatio(1.3),R=GasConstant(320))
```

We have **pre-defined gases** (at standard conditions), as well, for convenience:

```@example 0-BasicGasDynamics
Air
```

```@example 0-BasicGasDynamics
He
```

```@example 0-BasicGasDynamics
O2
```

```@example 0-BasicGasDynamics
CO2
```

```@example 0-BasicGasDynamics
H2
```

```@example 0-BasicGasDynamics
N2
```

#### Equations of state
We can apply the equation of state for a perfect gas to determine other quantities.
For example, suppose we have carbon dioxide at 1.2 kg/m^3 and 80 KPa. What is the temperature?

```@example 0-BasicGasDynamics
T = Temperature(Density(1.2),Pressure(80,units=KPa),gas=CO2)
```

You can switch the order of the arguments and it will still work:

```@example 0-BasicGasDynamics
T = Temperature(Pressure(80,units=KPa),Density(1.2),gas=CO2)
```

Then we can calculate the enthalpy, for example:

```@example 0-BasicGasDynamics
Enthalpy(T,gas=CO2)
```

What is the speed of sound of air at 20 degrees Celsius? Let's find out:

```@example 0-BasicGasDynamics
SoundSpeed(Temperature(20,units=C),gas=Air)
```

How about oxygen?

```@example 0-BasicGasDynamics
SoundSpeed(Temperature(20,units=C),gas=O2)
```

**Note: the default gas is air. So if you do not put the `gas=` argument in,
it will assume air at standard conditions.**

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

