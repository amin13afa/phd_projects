using ITensors 
using Plots
using Measurements   
using DelimitedFiles 

# lattice_large - lattice_small = 2 
function GrossNeveu(L,N,m,G²,sw)
    l = L-2;
    sites = siteinds("Fermion",L)
    ampoₗ = OpSum()
    ampoₛ = OpSum()
    # Large Lattice 
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
    Hₗ = MPO(ampoₗ, sites)
    ψₗ₀ = randomMPS(sites,100)
    ######################################
    ## small lattice 
    for j in 1:l-N
        ampoₛ -= 1im,"C",j,"Cdag",j+N
        ampoₛ += 1im,"C",j+N,"Cdag",j
    end
    for j in 1:N:l-N
        ampoₛ += (G²/2),"C * Cdag",j
    end
    for j in 1:l
        ampoₛ += (m*(-1)^j),"C * Cdag",j 
    end
    Hₛ = MPO(ampoₛ,sites[1:l])
    ψₛ₀ = randomMPS(sites[1:l],100)
    sweep = Sweeps(sw)
    setmaxdim!(sweep,repeat([1024],sw)...)
    setcutoff!(sweep,1E-12)
    
    eₗ₀,ψₗ = dmrg(Hₗ,ψₗ₀,sweep,outputlevel=0)
    eₛ₀,ψₛ = dmrg(Hₛ,ψₛ₀,sweep,outputlevel=0)
    
    #  Overlap computation
    v1 = ITensor(sites[l+1]) 
    for j in 1:size(v1)[1]
        v1[j] = 1/sqrt(2)
    end
    v2 = ITensor(sites[L])
    for j in 1:size(v2)[1]
        v2[j] = 1/sqrt(2)
    end
    v = ITensor(1.0)
    for j in 1:l
        v = v*dag(ψₛ[j])*ψₗ[j]
    end
    v = v*v1*ψₗ[l+1]
    v = v*v2*ψₗ[L]
    return inner(v,v), norm(v)
end

# L::Integer, N::Integer,G²::Float64,m::Float64,sw::Integer
result_res2 = Vector{ComplexF64}()
result_norm2 = Vector{ComplexF64}()

for j in 4:100
    println(j)
    res2 , norm_res2 = GrossNeveu(j,1,0.7,1.0,3); # change BD --> 100
    push!(result_res2, res2);
    push!(result_norm2, norm_res2);
end   

site_number2 = [x for x in 1:length(result_res2)]
result_res22 = real(result_res2)
result_norm22 = real(result_norm2)
# scatter(site_number2, 
#     result_res22 .± 1E-5, 
#     xlim=(-1,25),xticks=((-1:25)), 
#     ylim=(0.18,0.27), 
#     yticks=((0.18:0.001:0.23)),   
#     markersize=2,
#     xlabel="Site Number",
#     ylabel="Inner Product",
#     title="Overlap")
# savefig("GN_m04.svg")
writedlm("res_m07_100.txt",result_res22)
# writedlm("norm_m07_50.txt",result_norm22)
