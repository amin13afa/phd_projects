using ITensors
using Plots
using Measurements
L = 60;
N = 1;
G² = 1.0;
m = 0.5;
sites = siteinds("Fermion", L);
ITensors.state(::StateName"Plus", ::SiteType"Fermion") = [1/sqrt(2) 1/sqrt(2)]
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
          100       2       1e-16    
          300       10      1e-16    
          700       20      1e-16    
          1000      30      1e-18    
          1000      50      1e-18
         ])
    e, ψ = dmrg(H, ψ₀, sweep)
    return e,ψ,H
end

mps_vector = Vector{MPS}()
mpo_vector = Vector{MPO}()
ovr_vector = Vector{Float64}()
for j in 2:20
    println("j = ",j)
    e₀, ψ₀, H = GrossNeveu2(j)
    nrm = norm(inner(H,ψ₀,H,ψ₀) - inner(ψ₀',H,ψ₀)^2)
    push!(mps_vector, ψ₀)
    push!(mpo_vector, H)
    push!(ovr_vector,nrm)
end

function OverLap(ψ₁::MPS, ψ₂::MPS)
    len₁ = length(ψ₁)   # smaller lattice
    len₂ = length(ψ₂)
    v = ITensor(1.0)
#     v1 = state(inds(ψ₂[len₂-1])[1], "Plus")
    v2 = state(inds(ψ₂[len₂])[1], "Plus")
#     println(inds(ψ₂[len₂-1])[1])
    println(inds(ψ₂[len₂])[1])
    for j in 1:len₁
        v = v*dag(ψ₁[j])*ψ₂[j]
    end
#     v = v*dag(v1)*ψ₂[len₂-1]
    v = v*dag(v2)*ψ₂[len₂]
    return inner(v,v), norm(v)
end

ol_inner = Vector{Float64}()
ol_norm = Vector{Float64}()
for j in 1:(length(mps_vector)-1)
    inn, nrm = OverLap(mps_vector[j],mps_vector[j+1])
    push!(ol_inner, inn)
    push!(ol_norm, nrm)
end

err = [x for x in ovr_vector[1:end-1]];
# print(length(err))
minimum(err), maximum(err)

x = [x for x in 1:length(ol_norm)]
scatter(x,ol_norm .±err*10,
    xlim=(-1,22),xticks=((1:2:22)), 
    ylim=(0.48,0.69), 
    yticks=((0.50:0.02:0.66)),   
    markersize=2,
    xlabel="Site Number",
    ylabel="Inner Product",
    title="Overlap",
    legend=:topright,
    label="m₀=0.5,G²=1.0,err*10")
# savefig("GN_m05_G1_second.svg")