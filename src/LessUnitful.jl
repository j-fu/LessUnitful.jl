module LessUnitful
import Unitful
import Unitful: @u_str
import PhysicalConstants


"""
    unitfactor(quantity)

Calculate the unit factor, from a given quantity.
This is the numerical value of the quantity in unitful preferred units,
see [Notations](@ref). See [`unitful`](@ref) for the reciprocal operation.

### Example:
```jldoctest
julia> unitfactor(u"1mV")
0.001
julia> u"1mV"|> unitfactor
0.001
```
"""
unitfactor(quantity) = Unitful.ustrip(Unitful.upreferred(1.0*quantity))


"""
    @ufac_str

Obtain the unit factor of a quantity  -- its numerical value when converted to unitful preferred units.

### Example:
```jldoctest
julia> ufac"1mV"
0.001
```
"""
macro  ufac_str(x)
    Unitful=getproperty(@__MODULE__,:Unitful)
    quote
        $(Unitful).ustrip($(Unitful).upreferred(1.0*$(Unitful).@u_str($(x))))
    end
end

function _unitfactors(xs...)
    Unitful=getproperty(@__MODULE__,:Unitful)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(const $x = $(Unitful).ustrip($(Unitful).upreferred(1.0*$(Unitful).$x))))
    end
    code
end

"""
    @unitfactors

Declare unit factors as global constants.

### Example

```jldoctest
julia> @unitfactors cm
0.01
julia> 3cm
0.03
```

`@unitfactors cm` is equivalent to
```
const cm = ustrip(upreferred(u"1.0cm"))
```

and we can declare multiple unit factors at once:
```
@unitfactors mm cm km A V
```
"""
macro unitfactors(xs...)
    esc(_unitfactors(xs...))
end

"""
    unitful(x,unit)

Make number `x` "unitful". Assume `x` represents an unit factor
with respect to a unitful preferred unit. Create a unitful quantity in that unit
and convert it to `unit`.  See [`unitfactor`](@ref) for the reciprocal operation.

### Example

```jldoctest
julia> unitful(200,u"kPa")
0.2 kPa
```

Equivalent to 
```
unit((Float64(x)*Unitful.upreferred(unit)))
```
"""
unitful(x,unit)=unit((Float64(x)*Unitful.upreferred(unit)))


"""
    (unit)(x::Real)

Make number `x` "unitful" by calling [`unitful`](@ref).

### Example

```jldoctest
julia> u"kPa"(200)
0.2 kPa
```


```jldoctest
julia> 200 |> u"kPa"
0.2 kPa
```


This may be convenient when printing with units:
Instead of 
```jldoctest
@unitfactors μA  mA
x = 15mA
println(x/μA," μA")
# output
15000.0 μA
```
one can use 
```jldoctest
@unitfactors μA  mA
x = 15mA
println(x|>u"μA")  
# output
15000.0 μA
```
"""
(unit::Unitful.FreeUnits)(x::Real) = unitful(x,unit)





function _phconstants(xs...)
    Unitful=getproperty(@__MODULE__,:Unitful)
    PhysicalConstants=getproperty(@__MODULE__,:PhysicalConstants)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(const $x = Float64($(Unitful).ustrip($(Unitful).upreferred($(PhysicalConstants).CODATA2018.$x)))))
    end
    code
end

"""
    @phconstants

Declare numerical values of physical constants as unit factors with respect to unitful preferred units
as constants.  The information is obtained from [PhysicalConstants.CODATA2018](https://juliaphysics.github.io/PhysicalConstants.jl/stable/constants/#CODATA2018-1)

### Example:
```jldoctest
@phconstants N_A
# output
6.02214076e23
```

This is equivalent to
```
const N_A = ustrip(upreferred(PhysicalConstants.CODATA2018.N_A))
```

and we can "declare" multiple constants
```
@phconstants AvogadroConstant c_0
```


"""
macro phconstants(xs...)
    esc(_phconstants(xs...))
end



export unitfactor,@ufac_str, @unitfactors, unitful


export @phconstants
export @u_str

end # module LessUnitful

