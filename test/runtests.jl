using Test, Documenter, Unitful, LessUnitful

@phconstants AvogadroConstant
@unitfactors km  mol  dm nm
@testset "units" begin
    @test    AvogadroConstant==6.02214076e23
    @test    km==1000
    @test    ufac"cm"==0.01
end

@testset "allocs" begin
function unitful_ustr()
    x=float(ustrip(upreferred(1u"cm")))
end

function unitful_u()
    x=float(ustrip(upreferred(1Unitful.cm)))
end

function lessunitful_ustr()
    x=ufac"cm"
end

function lessunitful_ustr1()
    x=ufac"1cm"
end


function lessunitful_phstr()
    x=LessUnitful.ph"1N_A"
end

function lessunitful_local()
    @local_unitfactors cm
    x=cm
end


function lessunitful_unitfactor_q()
    x=1Unitful.cm|>unitfactor
end




function lessunitful_unitfactor_u()
    x=unitfactor(Unitful.cm)
end


function unitfactor_u()
    x=float(ustrip(1upreferred(Unitful.cm)))
end

    lessunitful_ustr()
    unitful_ustr()
    unitful_u()
    lessunitful_unitfactor_q()
    lessunitful_ustr1()
    unitfactor_u()
    lessunitful_unitfactor_u()
    lessunitful_local()
    
    n=@allocated lessunitful_local(); @test n==0

    n=@allocated lessunitful_ustr(); @test n==0
    n=@allocated unitful_ustr(); @test n==0
    n=@allocated unitful_u(); @test n==0
    n=@allocated lessunitful_unitfactor_q(); @test n==0
    n=@allocated lessunitful_ustr1(); @test n==0
    n=@allocated unitfactor_u(); @test n==0
    n=@allocated lessunitful_unitfactor_u(); @test n==0


end


DocMeta.setdocmeta!(LessUnitful, :DocTestSetup, :(using Unitful, LessUnitful); recursive=true)
doctest(LessUnitful)

