from qiskit import QuantumCircuit
from qiskit.quantum_info import entanglement_of_formation, entropy, Statevector
from qiskit.quantum_info import DensityMatrix, partial_trace
import numpy as np

c = QuantumCircuit(3,3)
# c.x(0)
c.h(0)
c.cx(0,1)
c.cx(0,2)
# c.draw('mpl')

def density_creation(circuit):
    return DensityMatrix.from_instruction(circuit)

def partialTrace(ρ):
    # single partite partial trace computation
    s_pt1 = []
    for j in range(len(ρ.dims())):
        s_pt1.append(partial_trace(ρ,[j]))
    # doubly parties  partial trace computation
    s_pt2 = []
    for j in range(len(ρ.dims())):
        s_pt2.append(partial_trace(ρ,[j,j+1]))
        if j+2 < len(ρ.dims()):
            s_pt2.append(partial_trace(ρ,[j,j+2]))
        else:
            break
    return s_pt1, s_pt2

def EOF(s_pt1,s_pt2):
    E_1 = 0
    E_2 = 0
    S_1 = 0
    S_2 = 0
    for j in range(len(ρ.dims())):
        E_1 += entanglement_of_formation(s_pt1[j]) 
        S_1 += entropy(s_pt1[j])
        S_2 += entropy(s_pt2[j])
    EOF_123 = (1.0/6)*(E_1 + S_1 + S_2)
    return EOF_123

ρ = density_creation(c)
s_tr1, s_tr2 = partialTrace(ρ)
print(EOF(s_tr1,s_tr2))

