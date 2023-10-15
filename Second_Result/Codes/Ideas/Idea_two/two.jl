using ITensors
using Plots

L = 20;     # number of staggered lattice sites => physical lattice sites are L/2 
N = 1;      # number of falvor
G² = 1.0;   # coupling constant
m = 0.5;    # bare mass of fermions
sites = siteinds("Fermion", L);


# Define a |+> state 
ITensors.state(::StateName"Plus", ::SiteType"Fermion") = [1/sqrt(2) 1/sqrt(2)]


# GrossNeveu2 function: using this function we compute the ground state for each of  lattice 
function GrossNeveu2(l)
    ampo = OpSum();
    for j in 1:l-N
        ampo -= 1im,"C",j,"Cdag",j+N
        ampo += 1im,"C",j+N,"Cdag",j
    end
    for j in 1:N:l-N
        ampo += (G²/2),"C * Cdag",j
    end
    for j in 1:l
        ampo += (m*(-1)^j),"C * Cdag",j
    end
    ψ₀ = randomMPS(sites[1:l],10)
    H = MPO(ampo, sites[1:l])
    sweep = Sweeps([
         "maxdim" "mindim" "cutoff" 
          10       2       1e-16    
          30       10      1e-16    
          50       20      1e-16    
          1000     30      1e-18    
          1024     50      1e-18
         ])
    e, ψ = dmrg(H, ψ₀, sweep)
    return e,ψ
end

# we use mps_vector for storing each of MPS 
mps_vector = Vector{MPS}()
for j in 2:20
    println("j = ",j)
    e₀, ψ₀ = GrossNeveu2(j)
    push!(mps_vector, ψ₀)
end

# OverLap function used to MPS overlap computation
# this function takes two mps (one is smaller than the other) and return the corresponding overlap and norm 
function OverLap(ψ₁::MPS, ψ₂::MPS)
    len₁ = length(ψ₁)
    len₂ = length(ψ₂)
    v = ITensor(1.0)
    # we use our defined state here, on the remaining sites of smaller lattice 
    v1 = state(inds(ψ₂[len₂-1])[1], "Plus")
    v2 = state(inds(ψ₂[len₂])[1], "Plus")
    for j in 1:len₁
        v = v*dag(ψ₁[j])*ψ₂[j]
    end
    v = v*dag(v1)*ψ₂[len₂-1]
    v = v*dag(v2)*ψ₂[len₂]
    return inner(v,v), norm(v)
end

# we use these two vectors in order to store the overlap and its norm for each of two MPS 
ol_inner = Vector{Float64}()
ol_norm = Vector{Float64}()
for j in 2:(length(mps_vector)-1)
    inn, nrm = OverLap(mps_vector[j],mps_vector[j+1])
    push!(ol_inner, inn)
    push!(ol_norm, nrm)
end

# plot the results
x = [x for x in 1:length(ol_norm)]
# plot using norm of overlaps 
scatter(x,ol_norm,
    xlim=(-1,22),xticks=((1:2:22)), 
    ylim=(0.3,1), 
    yticks=((0.4:0.1:1)),   
    markersize=2,
    xlabel="Site Number",
    ylabel="Inner Product",
    title="Overlap")
savefig("two_norm.svg")

# plot using inner product of overlaps
scatter(x,ol_inner,
    xlim=(-1,22),xticks=((1:2:22)), 
    ylim=(0.1,1), 
    yticks=((0.1:0.1:0.9)),   
    markersize=2,
    xlabel="Site Number",
    ylabel="Inner Product",
    title="Overlap")
savefig("two_inner.svg")