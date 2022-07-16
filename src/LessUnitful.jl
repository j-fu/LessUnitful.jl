module LessUnitful
import Unitful
import Unitful: @u_str, FreeUnits
import PhysicalConstants

##################################################################################
"""
    Unitfactors

The module LessUnitful.Unitfactors contains all unitfactors  of Unitful units.

### Example:

```jldoctest
julia> using LessUnitful.Unitfactors: cm,mm

julia> cm+mm
0.011
```
"""
module Unitfactors
using Unitful
allunits=filter(n->isdefined(Unitful,n)&&isa(getproperty(Unitful,n),Unitful.FreeUnits),names(Unitful,all=true))
for  u in allunits
    run = quote const $u=Unitful.float(Unitful.ustrip(Unitful.upreferred(1*Unitful.$u)))end
    eval(run)
end
end


"""
    unitfactor(quantity)

Calculate the unit factor of a quantity,
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

String macro for calculating the unit factor of a quantity, see also [`unitfactor`](@ref).

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

Declare unit factors of units as global constants.
!!! compat
     This macro will likely be removed in one of the next 0.x releases in favor of 

     ```
        using LessUnitful.Unitfactors: ...
     ```

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


export unitfactor, @ufac_str, @unitfactors

##################################################################################

"""
    unitful(x,unit)

Make number `x` "unitful". Assume `x` represents an unit factor 
of a quantity with respect to the corresponding products of powers of unitful preferred units.
Create this quantity and convert it to  `unit`.  

See [`unitfactor`](@ref) for the reciprocal operation.

### Example

```jldoctest
julia> unitful(200,u"kPa")
0.2 kPa
```

Equivalent to 
```
unit(Unitful.float(x*Unitful.upreferred(unit)))
```
"""
unitful(x,unit)=unit(Unitful.float(x*Unitful.upreferred(unit)))


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
using LessUnitful.Unitfactors: μA,mA
x = 15mA
println(x/μA," μA")
# output
15000.0 μA
```
one can use 
```jldoctest
using LessUnitful.Unitfactors: μA,mA
x = 15mA
println(x|>u"μA")  
# output
15000.0 μA
```
"""
(unit::FreeUnits)(x::Real) = unitful(x,unit)



export unitful, @u_str

##################################################################################
"""
   CODATA2018

The module LessUnitful.CODATA2018 contains all unitfactors for physical constants from PhysicalConstants.CODATA2018

### Example:

```jldoctest
julia> using LessUnitful.CODATA2018: N_A

julia> N_A
6.02214076e23
```
"""
module CODATA2018
import PhysicalConstants,Unitful
allconsts=filter(n->isa(getproperty(PhysicalConstants.CODATA2018,n),Unitful.AbstractQuantity),names(PhysicalConstants.CODATA2018,all=true))
for  c in allconsts
    run = quote const $c=Unitful.float(Unitful.ustrip(Unitful.upreferred(PhysicalConstants.CODATA2018.$c)))end
    eval(run)
end
end

"""
   CODATA2014

The module LessUnitful.CODATA2014 contains all unitfactors for physical constants from PhysicalConstants.CODATA2014

### Example:

```jldoctest
julia> using LessUnitful.CODATA2014: N_A

julia> N_A
6.022140857e23
```
"""
module CODATA2014
import PhysicalConstants,Unitful
allconsts=filter(n->isa(getproperty(PhysicalConstants.CODATA2014,n),Unitful.AbstractQuantity),names(PhysicalConstants.CODATA2014,all=true))
for  c in allconsts
    run = quote const $c=Unitful.float(Unitful.ustrip(Unitful.upreferred(PhysicalConstants.CODATA2014.$c)))end
    eval(run)
end
end


function _phconstants(xs...)
    Unitful=getproperty(@__MODULE__,:Unitful)
    PhysicalConstants=getproperty(@__MODULE__,:PhysicalConstants)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(const $x = Unitful.float($(Unitful).ustrip($(Unitful).upreferred($(PhysicalConstants).CODATA2018.$x)))))
    end
    code
end

"""
    @phconstants

Declare numerical values of physical constants as unit factors with respect to  unitful preferred units
as constants.  The information is obtained from [PhysicalConstants.CODATA2018](https://juliaphysics.github.io/PhysicalConstants.jl/stable/constants/#CODATA2018-1)

!!! compat
     This macro will likely be removed in one of the next 0.x releases in favor of 

     ```
        using LessUnitful.CODATA2018: ...
     ```


### Example:
```jldoctest
julia> @phconstants N_A
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

export @phconstants

end # module LessUnitful

