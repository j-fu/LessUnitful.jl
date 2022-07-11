```@eval
using Markdown
Markdown.parse("""
$(read("../../README.md",String))
""")
```

## Notations

The package accesses [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) to allow to define floating point constants for *units* like `cm`, `kPa`, `mV` etc. called *unit factors*. These *unit factors* relate these units to their corresponding products of powers of  [*unitful preferred units*](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.upreferred) in the sense of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl). 

By default the unitful preferred units are synonymous with the [*SI base units*](https://www.nist.gov/pml/owm/metric-si/si-units). By calling [Unitful.preferunits](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.preferunits) these reference values can be changed.




Example: Unit: `kN` ``\to`` representation in powers of SI base units: ``1000\cdot kg\cdot m\cdot s^{-2}`` 
``\to`` unit factor: 1000.0

```jldoctest
julia> using LessUnitful

julia> @unitfactors kN
1000.0
```



The unit factor  of a *quantity* like  `1cm`, `10kPa`, `1mV` is its numerical value  after conversion to products of powers of unitful preferred units.


Example: Quantity: `3kN` ``\to`` representation in powers of SI base units: ``3000\cdot kg\cdot m\cdot s^{-2}`` 
``\to`` unit factor: 3000.0

```jldoctest
julia> using LessUnitful

julia> ufac"3kN"
3000.0
```



## Index
```@index
```


## API

LessUnitful re-exports [`@u_str`](https://painterqubits.github.io/Unitful.jl/stable/manipulations/#Unitful.@u_str) from  [Unitful.jl](https://github.com/PainterQubits/Unitful.jl).

```jldoctest ustr
julia> using LessUnitful

julia> u"1.0mV"
1.0 mV
```

```@docs
unitfactor
@ufac_str
@unitfactors
unitful
LessUnitful.FreeUnits
@phconstants
``` 







