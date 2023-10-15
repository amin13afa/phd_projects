using ITensors
using Plots

L = 20;     # number of staggered lattice sites => physical lattice sites are L/2 
N = 1;      # number of falvor
G² = 1.0;   # coupling constant
m = 0.5;    # bare mass of fermions
sites = siteinds("Fermion", L);   


# GrossNeveu function: using this function we compute the ground state for 
# each of larger lattice and the smaller one  (ψₛ, ψₗ)
function GrossNeveu(L)
    lₛ = L-2;
    ampoₗ = OpSum()
    ampoₛ = OpSum()
    # Computation corresponding to larger Lattice
    for j in 1:L-N
        ampoₗ -= 1im,"C",j,"Cdag",j+N
        ampoₗ += 1im,"C",j+N,"Cdag",j
    end
    for j in 1:N:L-N
        ampoₗ += (G²/2),"C * Cdag",j
    end
    for j in 1:L
        ampoₗ += (m*(-1)^j),"C * Cdag",j
    end
    Hₗ = MPO(ampoₗ, sites[1:L])
    ψₗ₀ = randomMPS(sites[1:L],100)
    ######################################
   # Computation corresponding to smaller Lattice  
   # lattice_large - lattice_small = 2 
    for j in 1:lₛ-N
        ampoₛ -= 1im,"C",j,"Cdag",j+N
        ampoₛ += 1im,"C",j+N,"Cdag",j
    end
    for j in 1:N:lₛ-N
        ampoₛ += (G²/2),"C * Cdag",j
    end
    for j in 1:lₛ
        ampoₛ += (m*(-1)^j),"C * Cdag",j 
    end
    # here we apply "X" gate on the remaining sites of smaller lattice
    # X = C+Cdag
    ampoₛ += "C",lₛ+1,"Cdag",lₛ+1
    ampoₛ += "C",lₛ+2,"Cdag",lₛ+2

    Hₛ = MPO(ampoₛ,sites[1:L])
    ψₛ₀ = randomMPS(sites[1:L],100)
    # sweep definition
    sweep = Sweeps([
     "maxdim" "mindim" "cutoff" 
      10       2       1e-16    
      30       10      1e-16    
      50       20      1e-16    
      1000     30      1e-18    
      1024     50      1e-18
     ])
    eₗ₀,ψₗ = dmrg(Hₗ,ψₗ₀,sweep,outputlevel=0)
    eₛ₀,ψₛ = dmrg(Hₛ,ψₛ₀,sweep,outputlevel=0)
    return ψₛ, ψₗ
end

# using GrossNeveu function to compute the ground state for different size of lattice 
inner_sl = Vector{Float64}()
for j in 2:20
    println(j)
    ψₛ, ψₗ = GrossNeveu(j)
    push!(inner_sl, norm(inner(ψₛ,ψₗ)))
end


# Plot the results


x = [x for x in 1:length(norm_sl)]
# plot using norm of overlaps 
scatter(x,norm_sl,
    xlim=(-1,22),xticks=((1:2:51)), 
    ylim=(-0.02,0.1), 
    yticks=((-0.01:0.01:0.1)),   
    markersize=2,
    xlabel="Site Number",
    ylabel="Inner Product",
    title="Overlap")
savefig("one_norm.svg")

# plot using inner product of overlaps
scatter(x,norm_sl,
xlim=(-1,22),xticks=((1:2:51)), 
ylim=(-0.02,0.1), 
yticks=((-0.01:0.01:0.1)),   
markersize=2,
xlabel="Site Number",
ylabel="Inner Product",
title="Overlap")
savefig("one_inner.svg")