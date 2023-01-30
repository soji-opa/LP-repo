$title A LP problem  (TRNSPORT,SEQ=1)

$onText
This problem finds a least cost shipping schedule that meets
requirements at markets and supplies at factories.


Dantzig, G B, Chapter 3.3. In Linear Programming and Extensions.
Princeton University Press, Princeton, New Jersey, 1963.

This formulation is described in detail in:
Rosenthal, R E, Chapter 2: A GAMS Tutorial. In GAMS: A User's Guide.
The Scientific Press, Redwood City, California, 1988.

The line numbers will not match those in the book because of these
comments.

Keywords: linear programming, transportation problem, scheduling
$offText

variables x1 , x2 , x3 , of ;
Equations
eq1
eq2
eq3
eq4 ;
eq1 .. x1+2*x2 =g=3;
eq2 .. x3+x2 =g=5;
eq3 .. x1+x3 =e=4;
eq4 .. x1+3*x2 +3*x3=e=OF;
model LPEx1 / all / ;
Solve LPEx1 US LP min of;
display x1.l , x2.l , x3.l , of.l ;