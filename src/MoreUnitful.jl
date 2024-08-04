"""
        MoreUnitful
   
Make  unitful units callable.

!!! warning "This submodule commits  a form of type piracy"
    This behavior is not exported by default, but needs to be explicitely 
    enabled by `using LessUnitful.MoreUnitful`. 
    It is not recommended to use this in packages.
"""
module MoreUnitful
import Unitful
using LessUnitful: unitful, unitfactor
import Unitful: FreeUnits
struct CallableUnit end
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

Without `LessUnitful.MoreUnitful`, the result of this operation would be:
```
ERROR: DimensionError: kPa and 200 are not dimensionally compatible.
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
function CallableUnit(::Real) end # just for triggering the docstring, see https://github.com/JuliaDocs/Documenter.jl/issues/558

(unit::FreeUnits)(x::Real) = unitful(x,unit)
end
