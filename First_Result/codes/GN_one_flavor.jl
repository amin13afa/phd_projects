#=
This is a simple implementation of equation 8 of(Quantum Simulation of the N flavor Gross-Neveu Model)
 https://arxiv.org/abs/2208.05906  
 In this code we put "a" (flavor counter) equal to one 
=#

using ITensors 
#=
Function params are 
L: number of lattice site 
m_0 : mass 
g_o : interaction coefficient 
=#
function oneFlavorGN(L,m_0,g_0)
    sites = siteinds("Fermion",L)
    ampo = OpSum()

    # Creation of Hamiltonian
    for j in 1:L-1
        ampo += 1im,"C",j,"Cdag",j+1
        ampo += -1im,"Cdag",j,"C",j+1
        ampo += -1im,"C",j+1,"Cdag",j
        ampo += 1im,"Cdag",j+1,"C",j
    end
    # Mass  and interaction terms of Hamiltonian
    for j in 1:L
        ampo += 2*m_0*(-1)^j,"Cdag",j,"C",j
        ampo += g_0/2,"N",j
    end

    # Creation of MPO
    H_1 = MPO(ampo,sites) 
    #Initial random MPS
    psi0 = randomMPS(sites,10)
    # Determine DMTG params
    sweep = Sweeps(3)
    setmaxdim!(sweep,repeat([10],3)...)
    setcutoff!(sweep,1E-10)
    # DMRG computation
    e0_1,psi0_1 = dmrg(H_1,psi0,sweep) ;
    return e0_1
end

print(oneFlavorGN(6,1,2))