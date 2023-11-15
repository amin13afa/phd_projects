# Q1 
stu_ID = "9616895036";
A = [j for j in stu_ID[2:end]];
A = reshape(A,3,3);
A = parse.(Int64,A)
A

# Q2 
function det(C)
    if length(C) == 4
        B = C
        det = B[1]*B[end] - B[2]*B[end-1]
    elseif length(C) == 9
        det = 0
        for j in 1:3
            B = A[1:end .!=j , 1:end .!=1]
            det_3 = B[1]*B[end] - B[2]*B[end-1]
            det += A[j]*(-1)^(j+1)*det_3
        end
    else
        throw("DimensionMismatch: matrix is out of range")
    end
    return det
end 

# Q3 
det(A)

# Q4 
function tr(B)
    trace = 0
    for j in 1:(size(B)[1]+1):length(B)
        trace += B[j]
    end
    return trace
end 

# Q5 
function I(A)
    Iden = zeros(size(A))
    for j in 1:(size(Iden)[1]+1):length(Iden)
        Iden[j] = 1.0
    end
    return Iden
end

A_1 = ((A^2 - A*tr(A) + 0.5*((tr(A))^2 - tr(A^2))*I(A)) / (det(A)));

A_1 * A 
println(isequal(A_1*A,I(A)));