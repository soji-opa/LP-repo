$title Simple Dual linear programming model

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

Positive Variable x1, x2;
Variable ofdual;
Equation eqd1, eqd2, eqd3, eqd4;
eqd1 .. ofdual =e= 50*x1 + 80*x2;
eqd2 .. 3*x1 =g=6;
eqd3 .. 2*x1 + 4*x2 =g=10;
eqd4 .. 2*x1 + 5*x2 =g=8;

Model DualLP /all/;
solve DualLP us lp min ofdual;