$title A mixed integer linear programming transportation model with On/off state modeling of production side 

$onText
For more details please refer to Chapter 2 (Gcode2.12), of the following book:
Soroudi, Alireza. Power System Optimization Modeling in GAMS. Springer, 2017.
--------------------------------------------------------------------------------
Model type: MINLP
--------------------------------------------------------------------------------
Contributed by
Dr. Alireza Soroudi
IEEE Senior Member
email: alireza.soroudi@gmail.com
Soroudi, Alireza. Power System Optimization Modeling in GAMS. Springer, 2017.
DOI: doi.org/10.1007/978-3-319-62350-4

Udemy Course: Mastering Energy & PSO with GAMS

Student: Azeez Olasoji
$offText

Set
   i / s1*s3 /
   j / d1*d4 /;

Table c(i,j)
       d1      d2      d3      d4
   s1  0.0755  0.0655  0.0498  0.0585
   s2  0.0276  0.0163  0.096   0.0224
   s3  0.068   0.0119  0.034   0.0751;

Table data(i,*)
      'Pmin'  'Pmax'
   s1  100     450
   s2  50      350
   s3  30      500;

Parameter demand(j) / d1 217, d2 150, d3 145, d4 244 /;

Variable of, x(i,j), P(i);
Binary Variable U(i);
Equation eq1, eq2(i), eq3(i), eq4(j), eq5(i);

eq1..    of   =e= sum((i,j), c(i,j)*sqr(x(i,j)));
eq2(i).. P(i) =l= data(i,'Pmax')*U(i);
eq3(i).. P(i) =g= data(i,'Pmin')*U(i);

eq4(j).. sum(i, x(i,j)) =g= demand(j);
eq5(i).. sum(j, x(i,j)) =e= P(i);

P.lo(i)   = 0;
P.up(i)   = data(i,'Pmax');
x.lo(i,j) = 0;
x.up(i,j) = 100;

Model minlp1 / all /;
solve minlp1 using minlp minimizing of;