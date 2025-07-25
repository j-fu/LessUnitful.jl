# Changelog

## [1.2.1] - unreleased
- fix broken explicit imports of macros like `@unitfactors`

## [1.2.0] - 2025-02-08
- Disable affine units and relative temperature scales as not maintainable with the approach in this package

## [1.1.0] - 2024-08-04
- `Unitful.@u_str` is not anymore re-exported. Instead,  `using Unitful` should be used.
- The functor method  `(::Unitful.FreeUnits)(x::Real)` is now exported by the submodule `LessUnitful.MoreUnitful`.
  So if  something like `x=1|>u"cm"` is required (which should give 100cm because `1` is assumed to be a value
  in the SI Basic units in this method), one needs `LessUnitful.MoreUnitful`. Due to the type piracy behind this,
  using this in packages should be avoided. 
- Calculation of physical constants like `ph"N_A*e"` has been removed as this depended on undocumented internals of
  `Unitful.jl`. Just replace this by  `ph"N_A"*ph"e"`.
- Remove dependency on Unitful.lookup_units
- Require Julia 1.9

## [1.0.0] - 2024-08-04

- Allow to use macros with explicit imports.
- Add Aqua tests

## [0.6.1] - 2022-07-25
- Add `ensureSIBase` method

## [0.6.0] - 2022-07-21

- More revamping: now usage is allocation-free!
- Fix allocation test: take it out of the global context

## [0.5.0] - 2022-07-21

- Add PhysicalConstants evaluation to @ufac_str

Now we have two sets of Physical constants accessible this way:
 Na,q,k etc. from Unitful (didn't see them before)
 N_A,e, k_B from PhysicalConstants.CODATA2018

The former are buggy under Julia 1.8, see
