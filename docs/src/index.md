```@eval
using Markdown
Markdown.parse("""
$(read("../../README.md",String))
""")
```

## Notations

The package accesses [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) to allow to define floating point constants like `cm`, `kPa`, `mV` etc. called *unit factors* which are factors relative to products of powers of  [unitful preferred units](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.upreferred) in the sense of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl). By default these *unitful preferred units* are synonymous with the [*SI base units*](https://www.nist.gov/pml/owm/metric-si/si-units). However, by calling [Unitful.preferunits](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.preferunits) these reference values can be changed.


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







