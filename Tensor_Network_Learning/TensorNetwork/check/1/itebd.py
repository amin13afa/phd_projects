import numpy as np 
from ncon import ncon 
import scipy.linalg as sla
from scipy import integrate 


# func to def TFI Hamiltonian
def TFI(J:float,h:float,d:int,delta:float): 
    """
    H can be in the form of 
    H = J*h1 + h*h2  
    So we just need to determine J, h, d params
    """
    X = np.array([[0,1],[1,0]])
#     Y = np.array([[0,-1j],[1j,0]])
    Z = np.array([[1,0],[0,-1]])
    Id = np.identity(2)
    """
    we can add some control flow to check some string to construct hamiltonian    # just as an extra idea
    """
    h1 = ncon([Z,Z],[[-1,-3],[-2,-4]])
    h2 = 0.5*(ncon([X,Id],[[-1,-3],[-2,-4]]) + ncon([Id,X],[[-1,-3],[-2,-4]]))
    H = J*h1 + h*h2
    H = np.reshape(H,[d*d,d*d])
    Ug = sla.expm(-delta*H)
    Ug = np.reshape(Ug,[d,d,d,d])
    H = np.reshape(H,[d,d,d,d])
    return Ug, H
# function to def tensors
def Tensors(d:int,D:int):
    GA= np.random.rand(D,D,d)
    GB = np.random.rand(D,D,d)
    Gamma = [GA/np.linalg.norm(GA), GB/np.linalg.norm(GB)]
    LA = np.random.rand(D)
    LB = np.random.rand(D)
    Lambda = [LA/np.linalg.norm(LA), LB/np.linalg.norm(LB)]
    return Gamma, Lambda


def itebd(d,D,niter,tolerance):
    Gamma, Lambda = Tensors(d,D)
    Ug, H = TFI(-1,-1,2,0.1)
    Lambda_new = []
    for j in range(niter):
        A = np.mod(j,2)
        B = np.mod(j+1,2)
        tensors = [np.diag(Lambda[B]), Gamma[A],np.diag(Lambda[A]), Gamma[B], \
                   np.diag(Lambda[B]), Ug]
        connect = [[-1,1],[1,2,3],[2,4],[4,5,6],[5,-3],[3,6,-2,-4]]
        order = [1,4,5,2,3,6]
        theta = ncon(tensors, connect, order)
        # svd
        theta = np.reshape(theta,[D*d,D*d])
        U,S,Vd = np.linalg.svd(theta)
        Gamma[A] = U[:,0:D]
        Gamma[A] = np.reshape(Gamma[A],[D,d,D])
        Gamma[A] = np.transpose(Gamma[A],[0,2,1])
        Lambda_new.append(S[0:D]/np.linalg.norm(S[0:D]))
        Gamma[B] = Vd[0:D,:]
        Gamma[B] = np.reshape(Gamma[B],[D,D,d])
        diffA = np.linalg.norm(Lambda[A]-Lambda_new[A])
        if diffA < tolerance:
            print("success!")
            break
        else:
            print("iter: {} , diff: {}".format(j,diffA))
        Lambda[A] = Lambda_new[A]
        
        
        Gamma[A] = ncon([np.diag(1./Lambda[B]),Gamma[A]],[[-1,1],[1,-2,-3]])
        Gamma[B] = ncon([Gamma[B], np.diag(1./Lambda[B])],[[-1,1,-3],[1,-2]])
        Gamma[A] = Gamma[A]/np.linalg.norm(Gamma[A])
        Gamma[B] = Gamma[B]/np.linalg.norm(Gamma[B])
        Gamma = [Gamma[A],Gamma[B]]
        Lambda = [Lambda[A],Lambda[B]]
    return Gamma, Lambda
    
def Energy_computation(d:int,D:int,J:float,h:float,delta:float,niter:int) -> float:
    """_summary_

    Args:
        d (int): _Local dimension_
        D (int): _Bond dimension_
        J (float): _h1 coeff: J_
        h (float): _h2 coeff: h_
        delta (float): _delta_
        niter (int): _Number of iteration_

    Returns:
        _float_: _Total of energy and the ground state energy_
    """
    Gamma, Lambda = itebd(d,D,niter,delta)
    Ug, H = TFI(-1,-1,2,0.1)
    E = []
    for j in range(len(Gamma)):
        A = np.mod(j,2)
        B = np.mod(j+1,2)
        tensors = [np.diag(Lambda[B]), Gamma[A], np.diag(Lambda[A]),\
                  Gamma[B], np.diag(Lambda[B])]
        connect = [[-1,1],[1,2,-2],[2,3],[3,4,-4],[4,-3]]
        order = [1,4,3,2]
        theta = ncon(tensors, connect, order)
        Eb = ncon([theta, H, np.conj(theta)],[[1,2,3,4],[2,4,5,6],[1,5,3,6]], [5,6,1,2,3,4])
        E.append(Eb)
    E_tot = np.sum(E)
    E0 = E_tot/2.0
    return E_tot, E0
    


# E_tot, E_0 = Energy_computation()
# print("E_total = ", E_tot)
# print("E_0 = ", E_0)

print(Energy_computation.__doc__)
