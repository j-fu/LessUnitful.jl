module LessUnitful
import Unitful
import PhysicalConstants


"""
    @si_str

Return the numerical value of physical unit measured in SI basis units.

### Example:
```jldoctest
si"1mV"
# output

0.001
```
"""
macro  si_str(x)
    Unitful=getproperty(@__MODULE__,:Unitful)
    quote
        $(Unitful).ustrip($(Unitful).upreferred(1.0*$(Unitful).@u_str($(x))))
    end
end

function _siunits(xs...)
    Unitful=getproperty(@__MODULE__,:Unitful)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(const $x = $(Unitful).ustrip($(Unitful).upreferred(1.0*$(Unitful).$x))))
    end
    code
end

"""
    @siunits

Declare multiplicators for SI base units as global constants


### Example:
```jldoctest
@siunits mm cm km
3cm
# output

0.03
```
"""
macro siunits(xs...)
    esc(_siunits(xs...))
end


function _phconstants(xs...)
    Unitful=getproperty(@__MODULE__,:Unitful)
    PhysicalConstants=getproperty(@__MODULE__,:PhysicalConstants)
    code = Expr(:block)
    for x in xs
        push!(code.args, :(const $x = Float64($(Unitful).ustrip($(Unitful).upreferred($(PhysicalConstants).CODATA2018.$x)))))
    end
    code
end

"""
    @phconstants

Declare numerical values of physical constants in SI base units as global constant

### Example:
```jldoctest
@phconstants AvogadroConstant
AvogadroConstant
# output

6.02214076e23
```
"""
macro phconstants(xs...)
    esc(_phconstants(xs...))
end

export @siunits,@phconstants,@si_str

end # module LessUnitful
