$title Simple Primal linear programming model

$onText
For more details please refer to Chapter 2 (Gcode2.1), of the following book:
Soroudi, Alireza. Power System Optimization Modeling in GAMS. Springer, 2017.
--------------------------------------------------------------------------------
Model type: LP
--------------------------------------------------------------------------------
Contributed by
Dr. Alireza Soroudi
IEEE Senior Member
Udemy Course - Mastering Energy & PSO
$offText

positive variables u1,u2,u3;
variable of;
equations eq1,eq2,eq3;

eq1 .. of=e= 6*u1 + 10*u2 + 8*u3;
eq2 .. 3*u1 + 2*u2 + 2*u3 =l=50;
eq3 .. 4*u2 + 5*u3 =l=80;

model PrimalLP /all/;
solve PrimalLP us lp max of;

