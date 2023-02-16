$title Multi Object Economic Load Dispatch- using the pareto optimal front strategy

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

Set gen / g1*g5 /
    counter /c1*c11/;

Parameter report(*), rep(counter, *), repGen(counter, gen);

Scalar load / 400 /;

Scalars Eprice / 0.1 /
Elim ;


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

Equation eq1, eq2, eq3;

eq1.. TC =e= sum(gen, data(gen,'a')*P(gen)*P(gen) + data(gen,'b')*P(gen) + data(gen,'c'));

eq2.. TE =e= sum(gen, data(gen,'d')*P(gen)*P(gen) + data(gen,'e')*P(gen) + data(gen,'f'));

eq3.. sum(gen,P(gen)) =g= load;


P.lo(gen) = data(gen,'Pmin');
P.up(gen) = data(gen,'Pmax');

Model MOED / eq1, eq2, eq3 /;

*'reduce economic cost';
solve MOED using qcp minimizing TC;
report ('maxTE')=TE.l;
report ('minTC')=TC.l;

solve MOED using qcp minimizing TE;
report ('maxTC')=TC.l;
report ('minTE')=TE.l;

loop(counter,
Elim=( report('maxTE') - report('minTE') ) * ( (ord(counter) - 1 ) / ( card(counter) - 1) ) + report ('minTE');
TE.up =Elim;
solve MOED using qcp min TC;

rep(counter, 'TC') = TC.l;
rep(counter, 'TE') = TE.l;
repGen(counter, gen) = P.l(gen);
);

display rep;
display report;
display repGen;

