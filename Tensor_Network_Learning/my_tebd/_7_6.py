import numpy as np
from ncon import ncon 
import matplotlib.pyplot as plt 
import scipy.linalg as sla
from numpy.linalg import svd



# # define ITF function
def ITF(J,h):
    d = 2;
    X = np.array([[0,1],[1,0]])
    Z = np.array([[1,0],[0,-1]])
    Id = np.array([[1,0],[0,1]])
    Hzz = ncon([Z,Z],[[-1,-3],[-2,-4]])
    Hx = 0.5*(ncon([X,Id],[[-1,-3],[-2,-4]]) + ncon([Id,X],[[-1,-3],[-2,-4]]))
    H = -J*Hzz -h*Hx
    Hexp = np.reshape(H,[d*d,d*d])
    Ug = sla.expm(Hexp)
    Ug = np.reshape(Ug,[d,d,d,d])
    M = 0.5*ncon([Z,Z],[[-1,-3],[-2,-4]])
    return H, Ug, M
    



def create_theta(J,h,D, n_iter):
    _,Ug,_ = ITF(J,h)
    d = 2;
    A = np.random.rand(D,d,D)
    A = A / np.linalg.norm(A)
    B = np.random.rand(D,d,D)
    B = B / np.linalg.norm(B)
    sBA = np.random.rand(D,D)
    sBA = sBA / np.linalg.norm(sBA)
    sAB = np.random.rand(D,D)
    sAB = sAB / np.linalg.norm(sAB)
    T = [A,B]
    S = [sAB,sBA]
    
    for step in range(n_iter):
        a = np.mod(step,2)
        b = np.mod(step+1,2)
        tensors = [S[b],T[a],S[a],T[b],S[b],Ug]
        connect = [[-1,1],[1,2,3],[3,4],[4,5,6],[6,-3],[2,5,-2,-4]]
        order = [1,4,5,2,3,6]
        theta = ncon(tensors, connect, order)
        theta = np.reshape(theta,[d*D, d*D])
        U, S, Vd = svd(theta)
        T[a] = U[:,0:D]
        T[a] = np.reshape(T[a], [D,d,D])
        T[b] = Vd[0:D,:]
        T[b] = np.reshape(T[b], [D,d,D])
        T[a] = ncon([1./S[b], T[a]], [[-1,1],[1,-3,-2]])
        T[b] = ncon([T[b], 1./S[b]], [[-1,-3,1],[1,-2]])
        T[a] = T[a] / np.linalg.norm(T[a])
        T[b] = T[b] / np.linalg.norm(T[b])
        
    
    return T,S
    


T,S = create_theta(-1,0.5,5,10)
print(np.linalg.norm(T[0]))

print(np.linalg.norm(T[1]))








