# Macros for creating units and quantities

"""
    @displayedunits(qty,a)

Set the preferred units for displaying quantities and
create function `displayedunits` for returning these units and
`ushow` for converting quantities into these units.
"""
macro displayedunits(qty,a,dims)
  utype = isdefined(Unitful, qty) ? getfield(Unitful,qty) : qty
  esc(quote
      @derived_dimension($qty,$dims)

      displayedunits(::Type{$utype}) = @u_str($a)

      ushow(x::$utype) = uconvert(@u_str($a),x)

      end)
end

macro create_dimvar(qty,utype)
  esc(quote
          struct $qty{U<:$utype} <: ThermodynamicQuantity{U}
            val :: U
            name :: String
          end
          $qty(x::U) where {U<:$utype} = $qty(ushow(x),string($qty))
          $qty(x::Real) = $qty(x*displayedunits($utype),string($qty))
          default_unit(::Type{$qty}) = displayedunits($utype)

          export $qty
      end)
end

macro create_nondimvar(qty)
  esc(quote
          struct $qty{U<:Real} <: ThermodynamicQuantity{U}
            val :: U
            name :: String
          end
          $qty(x::Real) = $qty(x,string($qty))

          export $qty
      end)
end

macro create_gas(name,gamma,molarmass)
    esc(quote
            const $name = PerfectGas(γ = SpecificHeatRatio($gamma),
                                     R = GasConstant(Unitful.R/$molarmass))
            export $name
        end)
end
