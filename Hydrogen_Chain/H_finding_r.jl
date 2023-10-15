#= 
Using this file I am to construct a Hydrogen chain, and then try to find the optimal length 
between these hydrogen by which the energy of the system (total hydrogen chain ) is minimum among 
all possible energies.



To do that we use ITensor and its derivates packages
=#

using ITensors
using ITensorChemistry
# using ITensorParallel

# define a function to create our chain 
function create_molecule(m::String, r::Float64, rep::Int64)
    s = []
    for j in 1:rep
        push!(s,Atom(m, j*r , 0.0, 0.0))
    end
    return Molecule(s)
end

# Define a function to compute the energy at length r 

function energy_at_bond(r::Float64, rep::Int64)
    # define molecule geometry
    molecule = create_molecule("H",r,rep)
    # build electronic hamiltonian and solve HF
    hf = molecular_orbital_hamiltonian(molecule; basis="sto-3g")
    hamiltonian = hf.hamiltonian
    hartree_fock_state = hf.hartree_fock_state
    hartree_fock_energy = hf.hartree_fock_energy
    # hilbert space
    s = siteinds("Electron", 4; conserve_qns=true)
    H = MPO(hamiltonian, s)
    # initialize MPS to HF state
    ψhf = MPS(s, hartree_fock_state)
    # run dmrg
    dmrg_kwargs = (;
      nsweeps=10,
      maxdim=[10,20,30,40,50,100],
      cutoff=1e-8,
      noise=[1e-6, 1e-7, 1e-8, 0.0],
    )
    dmrg_energy, _ = dmrg(H, ψhf; nsweeps=10, outputlevel=0)
    return hartree_fock_energy, dmrg_energy
end


# bond distances
r⃗ = 0.7:0.1:1
println(typeof(r⃗))

energies = []
for r in r⃗
    push!(energies, (r,energy_at_bond(r,4)))
end
println(energies)

# function to find minimum of energy
function min_energy(energy)
    dm_energy = []
    for j in energy
        push!(dm_energy, j[2][2])
    end
    min = minimum(dm_energy)
    for j in energy
        if j[2][2] == min
            return j
        end
    end
end

println(min_energy(energies))




