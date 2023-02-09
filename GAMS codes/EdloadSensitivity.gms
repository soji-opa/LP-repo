$title Economic Load Dispatch with load sensitivity analysis

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





Set c /c1*c11/;
Set g /g1*g5/;

Parameter repGen(c,g);
Parameter report(c,*) ;

Scalar load /400/;

Table data(g,*)
      a     b      c     d     e     Pmin   Pmax
g1    3    20    100     2     5      3     28
g2  4.05  18.07  98.87  3.82  4.24   6.09   90
g3  4.05  15.55  104.26  5.01  2.15   5.69   68
g4  3.99  19.21  107.21  1.1   3.99   6.2    76
g5  3.88  26.18  95.31   3.55  6.88   5.57   19;

Variable P(g), OF;
Equation eq1, eq2;

eq1 ..OF =e= sum(g, data(g,'a')*P(g)*P(g) + data(g,'b')*P(g) + data(g,'c'));
eq2 .. sum(g,P(g)) =g= load;

Model ECD /eq1, eq2/;

loop(c,
load = sum(g, data(g,'Pmin')) + ((ord(c)-1)/(card(c)-1))*sum(g, data(g,'Pmax')-data(g,'Pmin'));
Solve ECD using qcp minimizing OF;

repGen(c,g) = P.l(g);
report(c,'OF') = OF.l;
report(c,'load') = load;
);

display repGen, report;

$onText


$libinclude gdxcc;

$gdxin ECD.gdx
$load repGen report

$gdxcc
$onEmpty
     display repGen;
     display report;
$offEmpty

$gdxcc
FileName = 'results.xlsx';
SheetName1 = 'repGen';
SheetName2 = 'report';

call XLSXwRiteData(FileName, SheetName1, repGen, rowLabels = c, colLabels = g);
call XLSXwRiteData(FileName, SheetName2, report, rowLabels = c, colLabels = ['OF', 'load']);

$offText
