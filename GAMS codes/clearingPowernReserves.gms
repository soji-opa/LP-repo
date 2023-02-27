$title Co-optimization of energy & reserves

Sets
i /A, B/;

Scalar
DE /130/
DR /20/;

Parameters
CE(i) 'Marginal cost of electricity production'
/
A 10
B 30/

CR(i) 'Reserve capactity offer cost'
/
A 0
B 30/

Pmax(i) 'capacity limit'
/A 100
B 100/;

Variables
TC 'Total system operation costs';

Positive Variables
P(i) 'Energy dispatch'
R(i) 'Reserve capacity dispatch'

Equations
obj 'objective function'
PB 'power balance equation'
RR 'Reserve requirement constraints'
CL(i) 'Capacity limits';

obj .. TC =e= sum(i, CE(i) * P(i) + CR(i) * R(i));
PB .. sum(i, P(i)) =e= DE;
RR .. sum(i, R(i)) =e= DR;
CL(i).. P(i) + R(i) =l= Pmax(i);

Model IE /all/;
solve IE minimizing TC using LP;