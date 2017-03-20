︠9f7f99dc-1f6f-47a9-a5c1-dcc5f94e434c︠
%md
http://homepages.math.uic.edu/~jan/mcs563/index.html

**TODO:** reproduce derivation of linkage from (Morgan '87) via first lecture
* ex7: properly derive the polynomial equations (including an alternative formulation with A^-1)
︡407aec07-a935-4889-b2c9-e6a59b567a81︡{"done":true,"md":"http://homepages.math.uic.edu/~jan/mcs563/index.html\n\n**TODO:** reproduce derivation of linkage from (Morgan '87) via first lecture\n* ex7: properly derive the polynomial equations (including an alternative formulation with A^-1)"}
︠cfb312f8-f94c-43ae-b6b6-b31bfc8c5de4s︠
load("folding.sage")
var([id+str(idx) for id in ['a','c','s','p'] for idx in [1,2]])

lhs = [a2*c1*c2 - a2*s1*s2 + a1*c1 - p1,
     a2*c2*s1 + a2*c1*s2 + a1*s1 - p2,
     c1^2 + s1^2 - 1,
     c2^2 + s2^2 - 1]

vars = (c1,c2,s1,s2)
grad_lhs = jacobian(lhs, vars)

def interpret(state):
    return {'th1': arctan2(state[s1], state[c1]).n(),
            'th2': arctan2(state[s2], state[c2]).n()}

grad_lhs

︡1683fbce-de23-4749-9806-39d698d05faa︡{"stdout":"(a1, a2, c1, c2, s1, s2, p1, p2)\n"}︡{"stdout":"[a2*c2 + a1      a2*c1     -a2*s2     -a2*s1]\n[     a2*s2      a2*s1 a2*c2 + a1      a2*c1]\n[      2*c1          0       2*s1          0]\n[         0       2*c2          0       2*s2]\n"}︡{"done":true}︡
︠0dc399cb-9bba-48b7-a99d-8270091df25e︠
%md
* ex3: how many solutions to the inverse position problem?
    * two, because the arm with two links can be bent either way
* ex4: solve the problem in a CAS
* ex5: solve a system of nonlinear equations by newton's method
︡9b9cb7f9-1c3e-49ef-b172-29dac1952700︡{"done":true,"md":"* ex3: how many solutions to the inverse position problem?\n    * two, because the arm with two links can be bent either way\n* ex4: solve the problem in a CAS\n* ex5: solve a system of nonlinear equations by newton's method"}
︠e4be16e8-42c5-48c4-a321-29f8c57aa833s︠
pars_a = {a1: 2, a2: 1}
# pars_a = {a1: .75, a2: .5}

goal_p = {p1: 1, p2: 0}
guess = {c1: cos(pi/6), s1: sin(pi/6), c2: cos(5*pi/6), s2: sin(5*pi/6)}

# guess = {c1: 1, s1: .01, c2: 1, s2: .01}

f = vector( f.subs(pars_a).subs(goal_p) for f in lhs )
J = grad_lhs.subs(pars_a).subs(goal_p)

f, J

# numeric_matrix(J.subs(guess)).eigenvalues()
    # check for singular matrix
︡a6420cf0-c72c-47c4-bb8e-099189066427︡{"stdout":"((c1*c2 - s1*s2 + 2*c1 - 1, c2*s1 + c1*s2 + 2*s1, c1^2 + s1^2 - 1, c2^2 + s2^2 - 1), [c2 + 2     c1    -s2    -s1]\n[    s2     s1 c2 + 2     c1]\n[  2*c1      0   2*s1      0]\n[     0   2*c2      0   2*s2])\n"}︡{"done":true}︡
︠3160bc6f-9e5f-426c-af8f-4481e192fbfas︠
def newton(f, J, pos, N = 100, eps = 1e-10, debug = True):
    x = numeric_dict(pos)

    for step in range(N):
        delta = - J.subs(x).inverse() * vector(f.subs(x))
        # print abs(delta.n()) # is the residual decreasing?

        x = op_dict_add(x, delta)
        # dict(zip(x.keys(), vector(x.values()) + delta))
            # TODO: use vectors instead of dicts for inner loop (replacing subs() calls)

        # pos = vector(x.values()) + delta
        # return dict(zip(x.keys(), pos))

        if (debug): print interpret(x)
        if (abs(vector(x.values())) < eps or abs(delta) < eps):
            return (x, True)

    return (x, False)

newton(f, J, guess)
︡88f3ae1c-e00e-45fd-8976-0382982dec7b︡{"stdout":"{'th2': -2.98810880256742, 'th1': 0.261799387799150}\n{'th2': -2.98083884606400, 'th1': 0.133181541071237}\n{'th2': -3.06024254060197, 'th1': 0.0803111349536595}\n{'th2': -3.10084786254269, 'th1': 0.0408031886811745}\n{'th2': -3.12121181562044, 'th1': 0.0203818813264821}\n{'th2': -3.13140117628946, 'th1': 0.0101914660874696}\n{'th2': -3.13649678261743, 'th1': 0.00509587091553305}\n{'th2': -3.13904470156237, 'th1': 0.00254795202756366}\n{'th2': -3.14031867550840, 'th1': 0.00127397808139548}\n{'th2': -3.14095566429066, 'th1': 0.000636989299135894}\n{'th2': -3.14127415890794, 'th1': 0.000318494681856889}\n{'th2': -3.14143340624482, 'th1': 0.000159247344972668}\n{'th2': -3.14151302991670, 'th1': 0.0000796236730925563}\n{'th2': -3.14155284175328, 'th1': 0.0000398118365160966}\n{'th2': -3.14157274767141, 'th1': 0.0000199059183860629}\n{'th2': -3.14158270063190, 'th1': 9.95295788983865e-6}\n{'th2': -3.14158767711265, 'th1': 4.97647714103671e-6}\n{'th2': -3.14159016534570, 'th1': 2.48824409517678e-6}"}︡{"stdout":"\n{'th2': -3.14159140947602, 'th1': 1.24411377556196e-6}\n{'th2': -3.14159203153534, 'th1': 6.22054450377638e-7}\n{'th2': -3.14159234257058, 'th1': 3.11019211609099e-7}\n{'th2': -3.14159249809099, 'th1': 1.55498803251308e-7}\n{'th2': -3.14159257586131, 'th1': 7.77284870407443e-8}\n{'th2': -3.14159261502660, 'th1': 3.85631942634637e-8}\n{'th2': -3.14159263375579, 'th1': 1.98340058484968e-8}\n{'th2': -3.14159264499621, 'th1': 8.59357985815126e-9}\n{'th2': -3.14159265119949, 'th1': 2.39030768238055e-9}\n"}︡{"stderr":"Error in lines 10-10\n"}︡{"stderr":"Traceback (most recent call last):\n  File \"/projects/sage/sage-7.3/local/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 976, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 1, in <module>\n  File \"\", line 4, in newton\n  File \"sage/matrix/matrix2.pyx\", line 8794, in sage.matrix.matrix2.Matrix.inverse (/projects/sage/sage-7.3/src/build/cythonized/sage/matrix/matrix2.c:66012)\n    return ~self\n  File \"sage/matrix/matrix0.pyx\", line 5281, in sage.matrix.matrix0.Matrix.__invert__ (/projects/sage/sage-7.3/src/build/cythonized/sage/matrix/matrix0.c:35751)\n    raise ZeroDivisionError(\"input matrix must be nonsingular\")\nZeroDivisionError: input matrix must be nonsingular\n"}︡{"done":true}︡
︠56eb9fa6-d68a-4466-a974-ab8af8994bdb︠
%md
lec01 -> lec04
︡89e926fd-a9c0-42b5-beec-f668ed4937f7︡{"done":true,"md":"lec01 -> lec04"}
︠608d5146-844a-41f8-a4c6-2af9a5e40750s︠
p(x) = x^4 - 3*x^3 + 5*x^2 - x + 3

def companion(p):
    # p: a polynomial with integer coefficients,
    #    normalized s.t. the highest degree term has coefficient 1
    d = p.degree(x)

    x_d = [Integer(-a) for (a,i) in p.coefficients()[0:-1]]
    return matrix.identity(d).delete_rows([0]).insert_row(d-1, x_d)

companion(p)
roots = companion(p).eigenvalues()

roots
[p(r) for r in roots]
︡85b8ef72-4a7e-4d0b-bd76-bdadace1eab6︡{"stdout":"[ 0  1  0  0]\n[ 0  0  1  0]\n[ 0  0  0  1]\n[-3  1 -5  3]\n"}︡{"stdout":"[-0.0919635860940476? - 0.7703974270524330?*I, -0.0919635860940476? + 0.7703974270524330?*I, 1.591963586094048? - 1.565021777806203?*I, 1.591963586094048? + 1.565021777806203?*I]\n"}︡{"stdout":"[0.?e-36 + 0.?e-36*I, 0.?e-36 + 0.?e-36*I, 0.?e-35 + 0.?e-35*I, 0.?e-35 + 0.?e-35*I]"}︡{"stdout":"\n"}︡{"done":true}︡
︠8ec089e9-aeb2-48bd-9cc1-aefc0496b50a︠


g = list(f) + [det(J)]
solve(g, vars) # try to solve overdetermined system in singular

︡930af96d-8c26-4c09-aac0-2bf877144eb9︡{"stdout":"[[c1 == 1, c2 == -1, s1 == 0, s2 == 0]]\n"}︡{"done":true}︡
︠f7a3a39a-66e9-4e9c-b564-d0e9379f1f3as︠

type(J)
isinstance(J, sage.matrix.matrix0.Matrix)
︡c45f04f6-2d9b-40e0-a5b3-ac66f00eaf91︡{"stdout":"<type 'sage.matrix.matrix_symbolic_dense.Matrix_symbolic_dense'>\n"}︡{"stdout":"True\n"}︡{"done":true}︡
︠35c38156-b63c-4992-9ba1-d74ac8efe855︠









