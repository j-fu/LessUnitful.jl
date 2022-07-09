[![linux-macos-windows](https://github.com/j-fu/LessUnitful.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/j-fu/LessUnitful.jl/actions/workflows/ci.yml)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://j-fu.github.io/LessUnitful.jl/dev)


LessUnitful
===========

Small package which provides convenience tools to access data from [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) and [PhysicalConstants.jl](https://github.com/JuliaPhysics/PhysicalConstants.jl) in an "unitless" way. This appears to be useful in projects using code which cannot easily made unit-aware, e.g. due to the use of sparse linear algebra.

## Installation

This package is in pre-release state. Versions 0.0.x are registered in https://github.com/j-fu/PackageNursery.
If you trust this registry, you can issue once

```
pkg> registry add https://github.com/j-fu/PackageNursery
```
and add the package via  
```
pkg> add LessUnitful
```


