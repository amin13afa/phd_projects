@time let 
    using ITensors 
    using Plots
    using Measurements   
    using DelimitedFiles 

# lattice_large - lattice_small = 2 
function GrossNeveu(L::Int64,N::Int64,m::Float64,G²::Float64)
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
    sweep = Sweeps([
         "maxdim" "mindim" "cutoff" 
          100      10      1e-10    
          200      10      1e-12    
          500      20      1e-14    
          700      30      1e-16    
          1000     50      1e-18
         ])
    eₗ₀,ψₗ = dmrg(Hₗ,ψₗ₀,sweep,outputlevel=1)
    eₛ₀,ψₛ = dmrg(Hₛ,ψₛ₀,sweep,outputlevel=1)
    # error computation
    nrm = norm(inner(Hₛ,ψₛ,Hₛ,ψₛ) - inner(ψₛ',Hₛ,ψₛ)^2)
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
    return inner(v,v), norm(v), nrm 
end

# L::Integer, N::Integer,G²::Float64,m::Float64,sw::Integer
result_inner = Vector{ComplexF64}();
result_norm = Vector{ComplexF64}();
result_error = Vector{ComplexF64}();

# GrossNeveu(L,N,m,G²)
for j in 4:2:18
    println(j)
    nnr , nrm, err = GrossNeveu(j,1,0.5,1.5); # change BD --> 100
    if err < 1e-6
        push!(result_inner, nnr);
        push!(result_norm, nrm);
        push!(result_error, err);
    else
        nnr , nrm, err = GrossNeveu(j,1,0.8,1.5); # change BD --> 100
        push!(result_inner, nnr);
        push!(result_norm, nrm);
        push!(result_error, err);
    end
end

site_number = [x for x in 1:length(result_inner)];
result_inner2 = real(result_inner);
result_norm2 = real(result_norm);
result_error2 = real(result_error);

error_bar = [sqrt(x) for x in result_error2[1:end]];

writedlm("m05_inner.txt",result_inner2)
writedlm("m05_norm.txt",result_norm2)
writedlm("m05_error.txt",result_error2)

scatter(site_number, 
    result_norm2.± error_bar, 
    xlim=(0,35),xticks=((0:5:35)), 
    ylim=(0.3,0.5), 
    yticks=((0.40:0.01:0.50)),   
    markersize=2,
    xlabel="Site Number",
    ylabel="Inner Product",
    label="m₀=0.7,G²=1.5",
    title="Overlap")
savefig("m05_2.svg")
end