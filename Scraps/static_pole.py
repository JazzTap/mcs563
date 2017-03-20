# http://ctms.engin.umich.edu/CTMS/index.php?example=Introduction&section=ControlStateSpace

var('t,s')
A = matrix( [[0,1,0],[980,0,-2.8],[0,0,-100]] )
B = matrix( [0,0,100] ).transpose()

print A.eigenvalues()
# [31.3049516849971, -31.3049516849971, -100.000000000000]


# == transfer function ==

# x = vector(function('x0')(t), function('x1')(t), function('x2')(t)) # constructor breaks
N = 3
xt = [function('x'+str(i))(t) for i in range(N)]
ut = function('u')(t)

tf = [(xt[i].diff(t,1) - sum(A[i,j]*xt[j] for j in range(N)) - B[i][0]*ut) \
      .laplace(t,s) for i in range(N)]
print tf

# [s*laplace(x0(t), t, s) - laplace(x1(t), t, s) - x0(0), s*laplace(x1(t), t, s) - 980.0*laplace(x0(t), t, s) + 2.8*laplace(x2(t), t, s) - x1(0), s*laplace(x2(t), t, s) - 100*laplace(u(t), t, s) + 100.0*laplace(x2(t), t, s) - x2(0)]


# == simulation w/o response ==

u = 0
x = [var('x'+str(i)) for i in range(N)]
des = [sum(A[i,j]*x[j] for j in range(N)) + B[i][0]*u for i in range(N)]

print desolve_system_rk4(des, x, ics=[0.01, 0, 0], ivar=t)
# FIXME: debug blackbox solver


# == design response ==

n = len(x); m = len(u); p = len(y); 
In = identity(n); Im = identity(m)

s*In - A	# ...


# == simulation w/ response ==

C = matrix( [1,0,0] )
y = sum(C[0,j]*x[j] for j in range(N))

# u(t) = F * y(t)

# x = function('x')(t)
# desolve(diff(x,t) - A*x(t) + B*u(t), x)
