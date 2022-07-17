```@eval
using Markdown
Markdown.parse("""
$(read("../../README.md",String))
""")
```

## Notations

The package provides tools to access [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) to define floating point constants for *units* like `cm`, `kPa`, `mV` etc. called *unit factors*. These *unit factors* relate units to their corresponding products of powers of  [*unitful preferred units*](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.upreferred) in the sense of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl). 

By default the unitful preferred units are synonymous with the [*SI base units*](https://www.nist.gov/pml/owm/metric-si/si-units). By calling [Unitful.preferunits](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.preferunits) these reference values can be changed.




Example: Unit: `kN` ``\to`` representation in powers of SI base units: ``1000\cdot kg\cdot m\cdot s^{-2}`` 
``\to`` unit factor: 1000.0

```jldoctest
julia> using LessUnitful

julia> @unitfactors kN
1000.0
```



The unit factor  of a *quantity* like  `5cm`, `10kPa`, `3mV` is its numerical value  after conversion to products of powers of unitful preferred units.


Example: Quantity: `3kN` ``\to`` representation in powers of SI base units: ``3000\cdot kg\cdot m\cdot s^{-2}`` 
``\to`` unit factor: 3000.0

```jldoctest
julia> using LessUnitful

julia> ufac"3kN"
3000.0
```

The unitfactor represents the numerical value of a unit/quatity expressed in preferred units:

```jldoctest
julia> using LessUnitful, Unitful

julia> unitfactor(u"cm")==Unitful.ustrip(Unitful.upreferred(u"1.0cm"))
true
```

Reciprocally, one can make a number "unitful", assuming it corresponds to one of the preferred units.
Assume `x` represents an unit factor 
of a quantity with respect to the corresponding products of powers of unitful preferred units.
Create this quantity and convert it to  `unit`: 

```jldoctest
julia> using LessUnitful, Unitful

julia> unitful(0.03,u"cm")==u"cm"(Unitful.float(0.03*Unitful.upreferred(u"cm")))
true
```




Providing these unit factors allows a "unitless" workflow with physical data which is characterized by the
following aspects:
- All calculations are done in numerical values corresponding to unitful preferred units (SI base units by default)
- Data input can be performed in at least two different ways:
   - Declare `@unitfactors cm` and enter e.g. `length=10*cm`
   - Enter "unitful" `length=10u"cm"` and actually provide `unitfactor(length)` to the "unitless" code 
- Data output can go as follows - assume result `p` is a pressure:
   - Declare `@unitfactors kPa` and do `println("p= ",p/kPa,"kPa")`
   - Alternatively, do `println(p|> u"kPa")`




## Obtaining unit factors
```@docs
unitfactor
@ufac_str
@unitfactors
```



## Creating unitful values
For convenience, lessUnitful re-exports [`@u_str`](https://painterqubits.github.io/Unitful.jl/stable/manipulations/#Unitful.@u_str) from  [Unitful.jl](https://github.com/PainterQubits/Unitful.jl).

```jldoctest ustr
julia> using LessUnitful

julia> u"1.0mV"
1.0 mV
```

```@docs
unitful
unitful(x,unit)
```


## Physical constants
```@docs
@phconstants
``` 







