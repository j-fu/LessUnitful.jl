[![linux-macos-windows](https://github.com/j-fu/LessUnitful.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/j-fu/LessUnitful.jl/actions/workflows/ci.yml)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://j-fu.github.io/LessUnitful.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://j-fu.github.io/LessUnitful.jl/dev)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

LessUnitful
===========

Small package which provides convenience tools to access quantities based on [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) and [PhysicalConstants.jl](https://github.com/JuliaPhysics/PhysicalConstants.jl) in an "unitless" way -- as floating point numbers representing the numerical value of a quantity expressed in preferred units (SI base units by default). This appears to be useful in projects using code which cannot easily made unit-aware, e.g. due to the use of sparse linear algebra. 

## Breaking changes in v1.0
- `Unitful.@u_str` is not anymore re-exported. Instead,  `using Unitful` should be used.
- The functor method  `(::Unitful.FreeUnits)(x::Real)` is now exported by the submodule `LessUnitful.MoreUnitful`.
  So if  something like `x=1|>u"cm"` is required (which should give 100cm because `1` is assumed to be a value
  in the SI Basic units in this method), one needs `LessUnitful.MoreUnitful`. Due to the type piracy behind this,
  using this in packages should be avoided. 
- Calculation of physical constants like `ph"N_A*e"` has been removed as this depended on undocumented internals of
  `Unitful.jl`. Just replace this by  `ph"N_A"*ph"e"`.
