## Analytic Symbolic Computation

#### [Apollonius](./Apollonius)

Interactive solution of Apollonius' circle problem in phcpy with d3 interface.

Requires: SageMath [kernel](https://stackoverflow.com/questions/39296020/how-to-install-sagemath-kernel-in-jupyter) with phcpy installed (precompiled binaries [pending](http://homepages.math.uic.edu/~jan/phcpy_doc_html/welcome.html), sorry).  
Execution: Open [Jupyter wrapper](https://github.com/JazzTap/mcs563/blob/master/Apollonius/apollonius_d3.ipynb) in a folder containing [the d3.js GUI binding](https://github.com/JazzTap/mcs563/blob/master/Apollonius/apollonius_d3.js).

![demo: resize](./Apollonius/2017-03-20%203s.gif)

Python & underlying equations derived from [the phcpy documentation](http://homepages.math.uic.edu/~jan/phcpy_doc_html/apollonius.html) by Jan Verschelde.

Javascript & underlying dependencies derived from [unofficial IPython API documentation](https://gist.github.com/tanyaschlusser/047148b1411ba4e05bb7) by Tanya Schlusser, [D3](https://strongriley.github.io/d3/tutorial/circle.html) [community](https://bl.ocks.org/mbostock/6123708) [wisdom](http://stackoverflow.com/questions/11336251/accessing-d3-js-element-attributes-from-the-datum), and too long spent wrangling requirejs().

![demo: drag outside, drag inside](./Apollonius/2017-03-20%2012s.gif)

![demo: drag across singularity](./Apollonius/2017-03-20%2021s.gif)
