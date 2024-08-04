```@docs
LessUnitful
```

## Why this package ?
We demonstrate this with an example.
Assume we have a nice function which calculates with unitful values:
```jldoctest demo
julia> using Unitful

julia> unitful_lsum(a::Unitful.Length, b::Unitful.Length) = a+b;

julia> unitful_lsum(10.0u"cm",1.0u"m")
1.1 m
```

Now we assume that there is a faster way to calculate the same sum with the caveat that the
implementation does not support unitful values, e.g. because it uses a binary package written in C.
(here, we just use a mock example, in reality, think about sparse linear algebra)
```jldoctest demo
julia> fast_lsum(a::Real, b::Real)=a+b;

```

If we want to use this method in a faster implementation of `unitful_area`, we might try to use `Unitful.ustrip`
to strip the units and to attach them back somehow afterwards. However, before stripping the arguments need to be brought to
a common unit. Canonically, this is the preferred unit of the corresponding dimension provided by Unitful (SI base unit by default).
```jldoctest demo
julia> function fast_unitful_lsum(a::Unitful.Length, b::Unitful.Length)
           a_stripped=a |> upreferred |> ustrip
           b_stripped=b |> upreferred |> ustrip
           fast_lsum(a_stripped, b_stripped)* unit(upreferred(a))
       end;

julia> fast_unitful_lsum(10.0u"cm",1.0u"m")
1.1 m
```

LessUnitful.jl provides
```jldoctest demo
julia> using LessUnitful, LessUnitful.MoreUnitful

julia> function fast_lessunitful_lsum(a::Unitful.Length, b::Unitful.Length)
           a_stripped=a |> unitfactor
           b_stripped=b |> unitfactor
           fast_lsum(a_stripped, b_stripped) |> u"m"
       end;

julia> fast_lessunitful_lsum(10.0u"cm",1.0u"m")
1.1 m
```

Also it helps to support a complete "less unitful" workflow:
```jldoctest demo
julia> fast_lsum(10.0ufac"cm",1.0ufac"m")
1.1
```

It is also possible to attach arbitrary units back in a way consistent to
the preferred units:
```jldoctest demo
julia> fast_lsum(10.0ufac"cm",1.0ufac"m") |> u"cm"
110.00000000000001 cm
```


## Notations

The package provides tools to access [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) to define floating point constants for *units* like `cm`, `kPa`, `mV` etc. called *unit factors*. These *unit factors* relate units to their corresponding products of powers of  [*unitful preferred units*](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.upreferred) in the sense of [Unitful.jl](https://github.com/PainterQubits/Unitful.jl). 

By default the unitful preferred units are synonymous with the [*SI base units*](https://www.nist.gov/pml/owm/metric-si/si-units). 



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
   - Alternatively, do `println(unitful(p,u"kPa"))`, or (with [`LessUnitful.MoreUnitful`](@ref)): `println(p|> u"kPa")`




## Obtaining unit factors
```@docs
LessUnitful.unitfactor
@ufac_str
@unitfactors
@local_unitfactors
```



## Creating unitful values

```@docs
unitful(x,unit)
```


```@docs
LessUnitful.MoreUnitful
LessUnitful.MoreUnitful.CallableUnit
```


## Physical constants

As already described above, the [`@ufac_str`](@ref)  macro can be used to extract the values of 
physical constants from  [PhysicalConstants.CODATA2018](https://juliaphysics.github.io/PhysicalConstants.jl/stable/constants/#CODATA2018-1).
```@docs
@ph_str
@phconstants
@local_phconstants
``` 

## Ensuring consistency with SI Base units

```@docs
ensureSIBase
```


## Changing preferred units

By calling [Unitful.preferunits](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.preferunits) 
the preferred units can be changed from SI base units to e.g. `g` for mass and `cm` for length.

In order to be effective, this needs to be called before any invocation of  [Unitful.upreferred](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.upreferred), and as a consequence, before 
any invocation of macros or functions from the LessUnitful package.

Due to [this issue](https://github.com/PainterQubits/Unitful.jl/issues/545) for Julia 1.8 it is advised to evaluate at least one of the
unit factors from LessUnitful immediately after calling `preferunits`.

Moreover, while it is convenient to use e.g. [`@unitfactors`](@ref) in the global scope of a package, it is important to
understand that values in global scope are evaluated  *during precompilation* and cannot be influenced by
[Unitful.upreferred](https://painterqubits.github.io/Unitful.jl/stable/conversion/#Unitful.upreferred).
Therefore it appears that packages which are designed to work consistently with other defaults than SI base units should 
avoid the use of [`@unitfactors`](@ref) and [`@phconstants`](@ref). The use of [`@local_unitfactors`](@ref) and [`@local_phconstants`](@ref),
and of [`@ufac_str`](@ref), [`unitfactor`](@ref), [`unitful`](@ref) does not suffer from this problem, though.

