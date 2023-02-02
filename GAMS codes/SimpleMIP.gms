$title Simple Mixed Integer Linear Programming model

$onText
For more details please refer to Chapter 2 (Gcode2.3), of the following book:
Soroudi, Alireza. Power System Optimization Modeling in GAMS. Springer, 2017.
--------------------------------------------------------------------------------
Model type: MIP
--------------------------------------------------------------------------------
Contributed by
Dr. Alireza Soroudi
IEEE Senior Member
email: alireza.soroudi@gmail.com
We do request that publications derived from the use of the developed GAMS code
explicitly acknowledge that fact by citing
Soroudi, Alireza. Power System Optimization Modeling in GAMS. Springer, 2017.
DOI: doi.org/10.1007/978-3-319-62350-4
$offText

Variable x, of;
Binary Variable y;
Equation eq1, eq2, eq3;

eq1.. -3*x +  2*y =g=  1;
eq2.. -8*x + 10*y =l= 10;
eq3..    x +    y =e= of;

Model MIP1 / all /;

x.up = 0.3;
solve MIP1 using mip maximizing of;
display y.l, x.l, of.l;