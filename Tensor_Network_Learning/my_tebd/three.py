# --------------- Network-0 --------------- # 
# Leading order cost:(chi^3)*(d^3)
chi = 10
d = 2
A = np.random.rand(chi,chi,d)
B = np.random.rand(chi,chi,d)
sBA = np.random.rand(chi,chi)
sAB = np.random.rand(chi,chi)
Ug = np.random.rand(d,d,d,d)

# TTv1.0.5.0P$:>:*D+?2>c*k*g3=''+3'-+-=O*S6O0S0=y'}3y-}->:lDk?d>clklgc='c+o'i
# +i=O`SlOfSf=yc}oyi}i>BEbEBNbM)'+)'+''')+')+$
tensors = [A,B,sBA,sAB,sBA,A.conj(),B.conj(),sBA.conj(),sAB.conj(),
	sBA.conj(),Ug]
connects = [[1,2,11],[3,4,12],[9,1],[2,3],[4,10],[5,6,13],[7,8,14],[9,5],
	[6,7],[8,10],[11,12,13,14]]
con_order = [1,2,4,9,6,10,11,5,13,14,7,3,12,8]
T_out = ncon(tensors,connects,con_order)

