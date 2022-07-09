using Test, Documenter, Unitful, LessUnitful

@phconstants AvogadroConstant
@unitfactors km  mol  dm nm
@testset "units" begin
    @test    AvogadroConstant==6.02214076e23
    @test    km==1000
    @test    ufac"cm"==0.01
end

DocMeta.setdocmeta!(LessUnitful, :DocTestSetup, :(using Unitful, LessUnitful); recursive=true)
doctest(LessUnitful)

