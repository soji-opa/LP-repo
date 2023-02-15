$title Economic Load Dispatch with different strategies

$onText
For more details please refer to Chapter 3 (Gcode3.1), of the following book:
Soroudi, Alireza. Power System Optimization Modeling in GAMS. Springer, 2017.
--------------------------------------------------------------------------------
Model type: QCP
--------------------------------------------------------------------------------
Contributed by
Dr. Alireza Soroudi
IEEE Senior Member
Email: alireza.soroudi@gmail.com
We do request that publications derived from the use of the developed GAMS code
explicitly acknowledge that fact by citing
Soroudi, Alireza. Power System Optimization Modeling in GAMS. Springer, 2017.
DOI: doi.org/10.1007/978-3-319-62350-4
$offText

Set Gen / g1*g5 /;

Parameter report(gen, *);

Scalar load / 400 /;

Scalars Eprice / 0.1 /
Elim / 90000 /;


$onText
Table data(Gen,*)
       a     b      c       Pmin  Pmax
   G1  3     20     100     28    206
   G2  4.05  18.07  98.87   90    284
   G3  4.05  15.55  104.26  68    189
   G4  3.99  19.21  107.21  76    266
   G5  3.88  26.18  95.31   19    53;
   
$offText

Table data(gen,*)

       a     b      c       d     e         f      Pmin  Pmax
   g1  3     20     100     2     -5        3      28    206
   g2  4.05  18.07  98.87   3.82  -4.24     6.09   90    284
   g3  4.05  15.55  104.26  5.01  -2.15     5.69   68    189
   g4  3.99  19.21  107.21  1.10  -3.99     6.2    76    266
   g5  3.88  26.18  95.31   3.55  -6.88     5.57   19    53;

Variable P(gen), TC, TE, OF;

Equation eq1, eq2, eq3, eq4;

eq1.. TC =e= sum(gen, data(gen,'a')*P(gen)*P(gen) + data(gen,'b')*P(gen) + data(gen,'c'));

eq2.. TE =e= sum(gen, data(gen,'d')*P(gen)*P(gen) + data(gen,'e')*P(gen) + data(gen,'f'));

eq3.. sum(gen,P(gen)) =g= load;

eq4.. OF =e= TC + TE * Eprice;

P.lo(gen) = data(gen,'Pmin');
P.up(gen) = data(gen,'Pmax');

Model EDS / eq1, eq2, eq3, eq4 /;

*'reduce economic cost';
solve EDS using qcp minimizing TC;
report (gen, 'ED')=P.l(gen);


*'reducing emission cost';
solve EDS using qcp minimizing TE;
report (gen, 'END')=P.l(gen);


*'including penalty into the OF cost fnc';
solve EDS using qcp minimizing OF;
report (gen, 'penalty')=P.l(gen); 

*'Limit emission strategy: minimizes total cost of fuel while enviromental polution is reduced';
TE.up=Elim;
solve EDS using qcp minimizing TC;
report (gen, 'limit')=P.l(gen); 

display report, TC.l, TE.l, OF.l;