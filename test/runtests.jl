using Test
using LessUnitful

@phconstants AvogadroConstant
@siunits km  mol  dm nm
@testset "units" begin
    @test    AvogadroConstant==6.02214076e23
    @test    km==1000
    @test    si"cm"==0.01
end
