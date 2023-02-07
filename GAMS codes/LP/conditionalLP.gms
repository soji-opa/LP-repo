$title A conditional LP problem 

$onText
This problem uses conditional statements in GAMS to solve an LP problem 

This of the mastering Energy & PSO in GAMS course - Alireza Souredi on Udemy

Keywords: linear programming
$offText


$onText
This is one way of writing it

set i / 1 * 5/;

variable x(i), OF;

x.lo(i) = -2;
x.up(i) = 2;

equations eq1, eq2, eq3;

eq1 .. 1=e= x('1') + x('2') + x('3');
eq2 .. 2=l= x('1') + x('2') + x('4') + x('5');
eq3 .. OF=e= sum(i, x(i));

model base /all/;

solve base min OF using LP;
$offText


$onText
set i / 1 * 5/;

variables x1 , x2 , x3 , x4, x5, of ;


equations eq1, eq2, eq3, eq4, eq5, eq6, eq7, eq8, eq9, eq10, eq11, eq12, eq13;

eq1 .. 1=e= x1 + x2 + x3;
eq2 .. 2=l= x1 + x2 + x4 + x5;
eq3 .. OF=e= x1 + x2 + x3 + x4 + x5;

eq4 .. x1 =l= -2;
eq5 .. x2 =l= -2;
eq6 .. x3 =l= -2;
eq7 .. x4 =l= -2;
eq8 .. x5 =l= -2;
eq9 .. x1 =g= 2;
eq10 .. x2 =g= 2;
eq11 .. x3 =l= 2;
eq12 .. x4 =g= 2;
eq13 .. x5 =g= 2;

model base /all/;

solve base min OF using LP;
$offText

$onText

This is one way of writing it 

--------------------------------------------------------------------------------
Model type: LP

Conditional LP problem formulation code
--------------------------------------------------------------------------------

$offText

$onText

Set i / 1 * 5/;

Variable x(i), OF;

x.lo(i) = -2;
x.up(i) = 2;

Equations eq1, eq2, eq3;

eq1 .. 1=e= sum(i $(ord(i) < 4), x(i));
eq2 .. 2=l= sum(i $(ord(i) <> 3), x(i));
eq3 .. OF=e= sum(i, x(i));

Model base /all/;

Solve base min OF using LP;

$offText

$onText

Set i / 1 * 5/;

Variable x(i), OF;

x.lo(i) $(ord(i)<3) = -2;
x.up(i) $(ord(i)<3) = 2;

x.lo(i) $(ord(i) >= 3) = -3;
x.up(i) $(ord(i) >= 3) = 3;

Equations eq1, eq2, eq3;

eq1 .. 1=e= sum(i $(ord(i) < 3 or ord(i) = 4), x(i));
eq2 .. 2=l= sum(i $(ord(i) <> 4), x(i));
eq3 .. OF=e= sum(i, x(i));

Model base /all/;

Solve base min OF using LP;
$offText

Set i / 1 * 5/;

Variable x(i), OF;

x.lo(i)  = -1;
x.up(i)  = 1;


Equations eq1, eq2, eq3, eq4, eq5;


eq1 .. 2=l= sum(i $(ord(i) <> 4), x(i));
eq2 .. 6=l= sum(i $(ord(i) <> 5), ord(i) * x(i));

eq3(i) $(ord(i) <=3) .. -2=l=x(i) + x(i+1);
eq4(i) $(ord(i) <=3) .. x(i) + x(i+1) =l= 2;

eq5 .. OF=e= sum(i, x(i));

Model base /all/;

Solve base min OF using LP;
