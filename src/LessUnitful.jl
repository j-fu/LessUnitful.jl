"""
$(read(joinpath(@__DIR__,"..","README.md"),String))
"""
module LessUnitful
import Unitful
import PhysicalConstants

##################################################################################

"""
    unitfactor(x)

Calculate the unit factor of a quantity or unit `x`.


### Example:
```jldoctest
julia> unitfactor(u"3mV")
0.003
julia> u"3mV"|> unitfactor
0.003
```

```jldoctest
julia> unitfactor(u"mV")
0.001
julia> u"mV"|> unitfactor
0.001
```

Compare this with the corresponding calculations with Unitful values:
```jldoctest
julia> u"1mV" |> u"V" |> Unitful.float
0.001 V
```


See [`unitful`](@ref) for the reciprocal operation:
```jldoctest
julia> u"1cm" |> unitfactor |> u"cm"
1.0 cm
```

"""
unitfactor(u::Unitful.FreeUnits)=Unitful.float(Unitful.ustrip(Unitful.upreferred(1u)))
unitfactor(q::Unitful.AbstractQuantity) = Unitful.float(Unitful.ustrip(Unitful.upreferred(q)))
unitfactor(r::Real)=r


#_ph_str(expr)=unitfactor(Unitful,eval(Unitful.lookup_units((PhysicalConstants.CODATA2018,),expr)))


"""
    @ufac_str

String macro for calculating the unit factor of a quantity or physical constant, see also [`unitfactor`](@ref).

### Example:
```jldoctest
julia> ufac"1mV"
0.001
```


This also allows to access  the physical constants q, c0, μ0, ε0, Z0, G, gn, h, ħ, Φ0, me, mn, mp, μB, Na, k, R, σ, R∞ defined in `Unitful.jl`.

See  [`@ph_str`](@ref)  for an alternative way to access physical constants.
"""
macro ufac_str(x)
    quote
        unitfactor($(Unitful).@u_str($(x)))
    end
end

# macro xufac_str(x)
#     esc(Expr(:call, :unitfactor, Unitful.lookup_units((PhysicalConstants.CODATA2018,Unitful),Meta.parse(x))))
# end


function _unitfactors(xs...)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(const $x = unitfactor($Unitful.$x)))
    end
    code
end

function _local_unitfactors(xs...)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(local $x = unitfactor($Unitful.$x)))
    end
    code
end

"""
    @unitfactors

Declare unit factors of units as global constants.


### Example

```jldoctest
julia> @unitfactors cm;

julia> 3cm
0.03
```

We can declare multiple unit factors at once:
```
@unitfactors mm cm km A V
```


```jldoctest
julia> @unitfactors cm mm;

julia> cm+mm
0.011
```

Compare this with the corresponding calculations with Unitful values:

```jldoctest
julia> u"1cm"+u"1mm"|> float
0.011 m
```
"""
macro unitfactors(xs...)
    esc(_unitfactors(xs...))
end




"""
    @local_unitfactors

Declare unit factors of units as local variables.


### Example

```jldoctest
function f()
    @local_unitfactors cm
    3cm
end
f()
# output
0.03
```

"""
macro local_unitfactors(xs...)
    esc(_local_unitfactors(xs...))
end


export unitfactor, @ufac_str, @unitfactors, @local_unitfactors

##################################################################################

"""
    unitful(x,unit)

Make number `x` "unitful", assuming that
the value of `x` is the expression of the quantity
as in preferred units.  
This  helps to convert numbers to unitful quantities
in a way compatible with [`unitfactor`](@ref).


### Example

```jldoctest
julia> unitful(200,u"kPa")
0.2 kPa
```

"""
unitful(x,unit)=unit(Unitful.float(x*Unitful.upreferred(unit)))

export unitful
##################################################################################


function _phconstants(xs...)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(const $x = unitfactor($PhysicalConstants.CODATA2018.$x)))
    end
    code
end

function _local_phconstants(xs...)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(local $x = unitfactor($PhysicalConstants.CODATA2018.$x)))
    end
    code
end

"""
    @phconstants

Declare numerical values of physical constants as unit factors with respect to  unitful preferred units
as constants.  The information is obtained from [PhysicalConstants.CODATA2018](https://juliaphysics.github.io/PhysicalConstants.jl/stable/constants/#CODATA2018-1)




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


"""
    @local_phconstants

Like [`@phconstants`](@ref) but declares a local variable.


### Example:
```jldoctest
function f()
    @local_phconstants N_A
    N_A
end
f()
# output
6.02214076e23
```
"""
macro local_phconstants(xs...)
    esc(_local_phconstants(xs...))
end


"""
    @ph_str

String macro for calculating the unit factor of a physical constant from [PhysicalConstants.CODATA2018](https://juliaphysics.github.io/PhysicalConstants.jl/stable/constants/#CODATA2018-1)




```jldoctest
julia> ph"N_A"
6.02214076e23
```

```jldoctest
julia> ph"N_A*e"
96485.33212331001
```


"""
macro ph_str(x)
    esc(Expr(:call, :unitfactor,Unitful.lookup_units((PhysicalConstants.CODATA2018),Meta.parse(x))))
end


export @phconstants, @local_phconstants, @ph_str


"""
    ensureSIBase()

Ensure that the preferred units are the SI base units. 
Calls to `Unitful.preferunits` after this will have no effect. 

```jldoctest
julia> ensureSIBase()
true
```
"""
function ensureSIBase()
    @local_unitfactors m kg s A K cd mol
    if !all([m,kg,s,A,K,cd,mol].==1.0)
        throw(ErrorException("Failed to ensure SI Base units due to previous call to Unitful.preferunits"))
    end
    true
end
export ensureSIBase


include("MoreUnitful.jl")
end # module LessUnitful

