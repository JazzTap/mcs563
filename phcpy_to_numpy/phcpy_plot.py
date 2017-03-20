from __future__ import print_function

import re
import numpy as np

from math import sqrt, ceil, floor

import matplotlib.pyplot as mpl
import matplotlib.cm as cm
# from matplotlib.lines import Line2D   # Line2D.filled_markers

def parse(raw, N):
    # convert substrings of form =* {} : {} {}* =* to tuples
    r = re.compile('=*\s*(\S+)\s+:\s+(\S+)\s*(\S*)[\n=]')
    tups = [r.findall(sol) for sol in raw]

    def munge(tup):
        # TODO: check name of each real- or complex-valued variable
        return complex(float(tup[1]), float(tup[2])) if tup[2] \
                else float(tup[1])

    # http://stackoverflow.com/a/15579807
    forms = np.append(np.array(['complex_', 'int_']),
                      np.repeat(['complex_', 'float_'], [N, 3])).tolist()
    dtype = {'names': [tup[0] for tup in tups[0]],
             'formats': forms}
    
    dtype['names'][0] = 'dt'
    
    print(dtype)

    sols = np.zeros(len(tups), dtype=dtype)
    for i in range(len(tups)):
        sols[i] = tuple(munge(tup) for tup in tups[i])

    return sols

def plot_phcpy(sols_raw, xs, rco_min = 1e-5):
    # sols_raw: structured numpy array, 1d w/ entries of form [dt, m, vars*, err, rco, res]
    # xs: list of strings, the labels of vars*
    
    # loc = [dict(zip(xs, x)) for x in sols[xs]]
    
    # exclude 'solutions' with small rco (reciprocal condition number)
    sols = filter(lambda u: u['rco'] > rco_min, sols_raw)
    print(len(sols), '/', len(sols_raw), ' solutions ok', sep='')
    sqrt_m = sqrt(len(sols))

    colors = cm.rainbow(np.linspace(0, 1, len(xs))) # stackoverflow 12236566
    COLS = int(ceil(sqrt_m))
    ROWS = int(floor(sqrt_m))
    fig, axs = mpl.subplots(ncols=COLS, nrows=ROWS,
                            sharey=True, sharex=True, figsize=(16,8))

    # plot each solution. TODO: encode axis redundantly by hue + brightness + shape
    for col, cor in zip(colors, xs):
        for ax, sol in zip(axs.reshape(COLS*ROWS), sols):

            # ax.axhline(color='.8'); ax.axvline(color='.8') # draw re/im axis
            ax.scatter(0, 0, marker = '+')
            ax.scatter(sol[cor].real, sol[cor].imag, color = col)
