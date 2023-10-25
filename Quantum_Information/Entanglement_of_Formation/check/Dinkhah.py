# setup
import sys
import subprocess 
import pkg_resources

required = {"numpy", "scipy", "qiskit", "h5py"}
installed = {pkg.key for pkg in pkg_resources.working_set}
missing = required - installed
if missing:
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', *missing ])

print("Installed")
##############################################
import numpy as np 
import scipy.sparse as ss
from scipy.linalg import norm
import h5py
import qiskit
from qiskit.quantum_info import Statevector,DensityMatrix,partial_trace
from qiskit.quantum_info import entanglement_of_formation, entropy

# Define the number of qubit
global qubit 
qubit = 4

# function to define labels
def labelCreation(qubit:int):
    labels = []
    for j in range(2**qubit):
        b = bin(j).replace("0b","")
        if len(b) < qubit:
            n = qubit - len(b)
            b = n*"0"+b
        labels.append(b)
    return labels

# function to define statevector and density matrix 
def StateCreation(coef,labels):
    if np.isclose(np.linalg.norm(coef),1):
        ψ = Statevector(np.zeros(2**qubit))
        for j in range(len(labels)):
            ψ += coef[j]*Statevector.from_label(labels[j])
        ρ = DensityMatrix(ψ)
    else:
        raise TypeError("The coefficient vector is not normalized")
    return ψ, ρ

# Define a function to take  partial trace 
# This func takes two input, density matrix and a list 
# In the input list, we are given the number of part we should partial trace over 

def PartialTrace(ρ,L:list):
    """
    ρ: Density matrix
    List: this list just can take 1,2,3
    """
    pt1 = []
    pt2 = []
    pt3 = []
        
    if np.isin(1,L) and len(ρ.dims()) > 1:
        for j in range(len(ρ.dims())):
            pt1.append(partial_trace(ρ,[j]))
    
    if np.isin(2,L) and len(ρ.dims()) > 2:
        for j in range(len(ρ.dims())-1):
            pt2.append(partial_trace(ρ,[j,j+1]))
            if j+2 < len(ρ.dims()):
                pt2.append(partial_trace(ρ,[j,j+2]))
                if j+3 < len(ρ.dims()):
                    pt2.append(partial_trace(ρ,[j,j+3]))
                    
    if np.isin(3,L) and len(ρ.dims()) > 3:
        for j in range(len(ρ.dims())-2):
            pt3.append(qiskit.quantum_info.partial_trace(ρ,[j,j+1,j+2]))
            if j+3 < len(ρ.dims()):
                pt3.append(qiskit.quantum_info.partial_trace(ρ,[j,j+1,j+3]))
                if j+1 < len(ρ.dims())-2:
                    pt3.append(qiskit.quantum_info.partial_trace(ρ,[j,j+2,j+3]))
                    
    partial_trace_func = {
        "partial_trace_1" : pt1,
        "partial_trace_2" : pt2,
        "partial_trace_3" : pt3
    }
                        
    return partial_trace_func     

# Function to compute entanglement of formation(EOF) for a three-partite system
def EOF_3(ρ_pt:dict): 
    """
    ρ_pt : A dictionary containing partial trace over density matrix 
    """
    eof_1 = []
    eof_2 = []
    entropy_1 = []
    entropy_2 = []
    if len(ρ_pt['partial_trace_1']) == 0:
        pass
    else:
        for j in range(len(ρ_pt['partial_trace_1'])):
            eof_1.append(entanglement_of_formation(
                ρ_pt['partial_trace_1'][j]))
            entropy_1.append(entropy(ρ_pt['partial_trace_1'][j]))
    
    if len(ρ_pt['partial_trace_2']) == 0:
        pass 
    else:
        for j in range(len(ρ_pt['partial_trace_2'])):
            eof_2.append(entanglement_of_formation(
                ρ_pt['partial_trace_1'][j]))
            entropy_2.append(entropy(ρ_pt['partial_trace_2'][j]))
            
            
    eof_1 = np.array(eof_1)
    eof_2 = np.array(eof_2)
    entropy_1 = np.array(entropy_1)
    entropy_2 = np.array(entropy_2)
    EOF = np.sum(eof_1+eof_2+entropy_1+entropy_2)/6
    return EOF
##########################################################
# check created labels 
labels = labelCreation(qubit)
# Coefficients determination 
coef = np.zeros(2**qubit)
coef[0] = 0.5;
coef[5] = 0.5;
coef[10] = 0.5;
coef[15] = 0.5;
# Create quantum state 
ψ, ρ = StateCreation(coef, labels)
# Take partial trace over one part 
ρ_pt_1 = PartialTrace(ρ, [1])


    
V = np.zeros((8,1))
D = []
start = -1.0;
stop = 1.0;
num = 50;

for v0 in np.linspace(start, stop, num):
    V[0,0] = v0
    for v1 in np.linspace(start, stop, num):
        V[1,0] = v1
        for v2 in np.linspace(start, stop, num):
            V[2,0] = v2
            for v3 in np.linspace(start, stop, num):
                V[3,0] = v3
                for v4 in np.linspace(start, stop, num):
                    V[4,0] = v4
                    for v5 in np.linspace(start, stop, num):
                        V[5,0] = v5
                        for v6 in np.linspace(start, stop, num):
                            V[6,0] = v6
                            for v7 in np.linspace(start, stop, num):
                                V[7,0] = v7
                                ρ = DensityMatrix(np.outer(V,V))
                                ρ_2 = DensityMatrix(np.matmul(ρ.data,ρ.data))
                                if ρ.is_valid() and ρ_2.is_valid():
                                    D.append(ρ)
                                    
print("Len(D) = ",len(D))
 

# Javidan ans
ans = []
for j in range(3):
    M = ρ_pt_1["partial_trace_1"][j].data
    r_M,c_M,v_M = ss.find(M)
    for k in range(len(D)):
        A = D[k].data
        r_A,c_A,v_A = ss.find(A)
        for kk in range(len(D)):
            B = D[kk].data
            r_B, c_B, v_B = ss.find(B)
            if not v_A[0] - v_B[0] == 0:
                p = (v_M[0] - v_B[0])/(v_A[0] - v_B[0])
                for m in range(len(r_M)):
                    if (np.abs(v_M[m] - (p*v_A[m] + (1-p)*v_B[m]))) < 1e-2:
                        ans.append((p,A,B))                        


hf = h5py.File("Dinkhah_data.h5","w")
hf.create_dataset("ans", data=ans)
hf.close()
