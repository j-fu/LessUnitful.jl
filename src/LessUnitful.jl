module LessUnitful
import Unitful
import Unitful: @u_str, FreeUnits
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
unitfactor(u) = unitfactor(Unitful,u)
unitfactor(U::Module,u::Unitful.FreeUnits) = unitfactor(U,1u)
unitfactor(U::Module,quantity) = U.float(U.ustrip(U.upreferred(quantity)))

function _ufac_str(x)
    Unitful=getproperty(@__MODULE__,:Unitful)
    PhysicalConstants=getproperty(@__MODULE__,:PhysicalConstants)
    code = Expr(:block)
    push!(code.args, :(unitfactor($(Unitful),eval($(Unitful).lookup_units(($(PhysicalConstants).CODATA2018,$(Unitful)), Meta.parse($x))))))
    code
end

"""
    @ufac_str

String macro for calculating the unit factor of a quantity, see also [`unitfactor`](@ref).

### Example:
```jldoctest
julia> ufac"1mV"
0.001
```

This macro allows as wellto obtatin unit factors from physical constants from  [PhysicalConstants.CODATA2018](https://juliaphysics.github.io/PhysicalConstants.jl/stable/constants/#CODATA2018-1)

```jldoctest
julia> ufac"N_A"
6.02214076e23
```

```jldoctest
julia> ufac"N_A*e"
96485.33212331001
```

"""
macro  ufac_str(x)
    esc(_ufac_str(x))
end



macro xufac_str(x)
    Unitful=getproperty(@__MODULE__,:Unitful)
    quote
        unitfactor($(Unitful),$(Unitful).@u_str($(x)))
    end
end



function _unitfactors(xs...)
    Unitful=getproperty(@__MODULE__,:Unitful)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(const $x = unitfactor($(Unitful),$(Unitful).$x)))
    end
    code
end

function _local_unitfactors(xs...)
    Unitful=getproperty(@__MODULE__,:Unitful)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(local $x = unitfactor($(Unitful),$(Unitful).$x)))
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

Make number `x` "unitful". 



### Example

```jldoctest
julia> unitful(200,u"kPa")
0.2 kPa
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
@unitfactors μA mA;
x = 15mA
println(x/μA," μA")
# output
15000.0 μA
```
one can use 
```jldoctest
@unitfactors  μA mA
x = 15mA
println(x|>u"μA")  
# output
15000.0 μA
```


See [`unitfactor`](@ref) for the reciprocal operation:
```
julia>  0.05|> u"cm" |> unitfactor
0.05
```


"""
function unitful end

(unit::FreeUnits)(x::Real) = unitful(x,unit)



export unitful, @u_str

##################################################################################


function _phconstants(xs...)
    Unitful=getproperty(@__MODULE__,:Unitful)
    PhysicalConstants=getproperty(@__MODULE__,:PhysicalConstants)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(const $x = unitfactor($(Unitful),$(PhysicalConstants).CODATA2018.$x)))
    end
    code
end

function _local_phconstants(xs...)
    Unitful=getproperty(@__MODULE__,:Unitful)
    PhysicalConstants=getproperty(@__MODULE__,:PhysicalConstants)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(local $x = unitfactor($(Unitful),$(PhysicalConstants).CODATA2018.$x)))
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

export @phconstants, @local_phconstants

end # module LessUnitful

