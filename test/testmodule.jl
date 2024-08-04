module testmodule
using Test
using LessUnitful: LessUnitful, @unitfactors, @local_unitfactors, @phconstants, @local_phconstants, @ufac_str, @ph_str

@unitfactors nm dm
@phconstants N_A

function runtests()
    @test nm==1.0e-9
    @test dm==1.0e-1
    @test N_A==6.02214076e23

    @local_unitfactors kg kPa
    @test kg==1.0
    @test kPa==1000.0
    @local_phconstants e
    @test e==1.602176634e-19

    @test ufac"mm"==0.001
    @test ph"e"==1.602176634e-19
end


end
