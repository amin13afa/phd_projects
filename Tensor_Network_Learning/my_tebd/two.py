import numpy as np 
from ncon import ncon

# --------------- Network-0 --------------- # 
# Leading order cost (guaranteed optimal): (chi^3)*(d^2)
chi = 10
d = 2
A = np.random.rand(chi,chi,chi)
B = np.random.rand(chi,d,d)
sBA = np.random.rand(chi,chi)
sAB = np.random.rand(chi,chi)

# TTv1.0.5.0P$p>6+=+9?>P(W(S>=+'/9+0/0=E'I9E0I0=]'a9]0a8)'')++''9]T^'4k8$
tensors = [A,B,sBA,sAB,sBA]
connects = [[1,2,-2],[3,4,-4],[-1,1],[2,3],[4,-3]]
con_order = [3,2,1,4]
T_out = ncon(tensors,connects,con_order)

