using Test
using Unitful
Unitful.preferunits(u"cm",u"g")
using LessUnitful

@testset "runtest1/upreferred" begin
    @test ufac"cm"==1.0
    @test ufac"V"== 1.0e7
    @test ufac"ε0"==8.85418781762039e-21
end
