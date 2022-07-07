LessUnitful
===========

Small package which provides a number of macros allowing to access data from Unitful.jl and PhysicalConstants.jl in an "unitless" way. This appears to be useful in projects using code which cannot easily made unit-aware, e.g. due to the use of sparse linear algebra.

All numbers correspond to quantities expressed  [preferred units](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.upreferred)
in the sense of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl). By default these are the SI basis units.


## `@siunits`

Declare multiplicators for SI base units as global constants

```
julia> @siunits cm
0.01
julia> 3cm
0.03
```

This is equivalent to
```
const cm = ustrip(upreferred(u"1.0cm"))
```

and we can "declare" multiple units at once:
```
@siunits mm cm km A V
```

## `@phconstants`

Declare numerical values of physical constants in SI base units as global constant. The information is obtained from [PhysicalConstants.CODATA2018](https://juliaphysics.github.io/PhysicalConstants.jl/stable/constants/#CODATA2018-1)

```
@phconstants N_A
6.02214076e23
```

This is equivalent to
```
const N_A = ustrip(upreferred(PhysicalConstants.CODATA2018.N_A))
```

and we can "declare" multiple constants
```
@phconstants N_A c_0
```


## `@si_str`

Return the numerical value of a physical quantity.
```
julia> si"1mV"
0.001
```

