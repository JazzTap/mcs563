︠2c2f27d6-86a2-41cb-8c87-5ff369cbbf27s︠
# check that calling functions via subs() is fast enough
guess_th = {c1: cos(pi/60), s1: sin(pi/60), c2: cos(59*pi/60), s2: sin(59*pi/60)}

import time
def try_subs():
    st = time.time()
    f.subs(guess_th), J.subs(guess_th)
    nd = time.time()
    return nd - st

times = [try_subs() for i in range(100)]
print(min(times), mean(times), max(times))
︡91880461-e4b8-4fe9-828f-4cdf9f44738c︡{"stderr":"Error in lines 1-1\nTraceback (most recent call last):\n  File \"/projects/sage/sage-7.3/local/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 976, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 1, in <module>\nNameError: name 'c1' is not defined\n"}︡{"done":true}︡
︠5006248b-af8f-4748-867d-ee7a87d6ca8f︠

# are all the equations converging to a root?
test = [f.subs(pars_a).subs(goal_p) for f in lhs]

print [f.subs(guess_th).n() for f in test]
print [f.subs(pos).n() for f in test]









