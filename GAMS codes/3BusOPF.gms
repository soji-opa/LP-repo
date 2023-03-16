$title Optimal power flow for a three-bus system

$onText
For more details please refer to Chapter 6 (Gcode6.2), of the following book:
Soroudi, Alireza. Power System Optimization Modeling in GAMS. Springer, 2017.
--------------------------------------------------------------------------------
Model type: LP
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

$onText
The code defines the following sets:

bus: a set of buses in the system, indexed from 1 to 3.
Gen: a set of generating units in the system, indexed from g1 to g3.

conex: a set of bus pairs representing the network connectivity matrix.
Each pair connects two buses, and there are three pairs in total.

GBconect: a set of pairs representing the connectivity of generating units to buses.
Each pair represents a generator connected to a bus.



The code defines the following parameters and tables:

Sbase: a scalar representing the base power in the system.
GenData: a table with generator characteristics, including their bus connection, minimum and maximum power outputs, and cost coefficients.
BusData: a table with the power demand at each bus.
branch: a table with technical characteristics of each branch, including its impedance and thermal limit.
The code defines the following variables:

OF: the objective function, which is the total cost of generation.
Pij: the power flow on each branch.
Pg: the output of each generator.
delta: the phase angle of each bus.
The code defines the following equations:

const1: an equation that calculates the power flow on each branch as a function of the phase angles of the connected buses and the impedance of the branch.
const2: an equation that enforces the power balance equation at each bus, accounting for the power generation, power demand, and power flow on each branch connected to the bus.
const3: an equation that defines the objective function as the sum of the cost coefficients of each generator multiplied by its output.
The code defines the following model attributes:

Pg.lo and Pg.up: lower and upper bounds on the output of each generator, based on its minimum and maximum output levels.
delta.up and delta.lo: upper and lower bounds on the phase angle of each bus.
delta.fx: a fixed value constraint that sets the phase angle of the slack bus (bus 3) to zero.
Pij.up and Pij.lo: upper and lower bounds on the power flow on each branch, based on its thermal limit.
solve: a command that solves the model using linear programming to minimize the objective function.
The code defines the following output:

report: a table with the results of the load flow analysis, including the power generation, phase angles, power demand, and locational marginal prices (LMPs) at each bus.
Pij.l: a table with the final power flows on each branch.
Congestioncost: a scalar representing the total congestion cost, which is the product of the power flow on each branch and the dif
$offText

Set
   bus        / 1*3   /
   slack(bus) / 3     /
   Gen        / g1*g3 /;

Scalar Sbase / 100 /;

Alias (bus,node);

Table GenData(Gen,*) 'generating units characteristics'
       b   pmin  pmax
   g1  10  0     65
   g2  11  0     100;
* -----------------------------------------------------

Set GBconect(bus,Gen) 'connectivity index of each generating unit to each bus' / 1.g1, 3.g2 /;

Table BusData(bus,*) 'demands of each bus in MW'
       Pd
   2  100;

Set conex 'bus connectivity matrix' / 1.2, 2.3, 1.3 /;
conex(bus,node)$(conex(node,bus)) = 1;

* The above code says, connect bus & node, if node & bus is 1
* Thus we connect 1-2 & 2-1; 2-3 * 3-2; 1-3 & 3-1


Table branch(bus,node,*) 'network technical characteristics'
        x     Limit
   1.2  0.2   100
   2.3  0.25  100
   1.3  0.4   100 ;
   
$onText
**************************************************************
The first equation is defining the parameter branch for a given pair of buses (bus and node) and a parameter called x.
It is saying that if the value of branch(bus,node,'x') is 0,
then the value of branch(node,bus,'x') should be used instead.

The second equation is defining the parameter branch again, this time for the same pair of buses and a parameter called Limit.
It is saying that if the value of branch(bus,node,'Limit') is 0, then the value of branch(node,bus,'Limit') should be used instead.

The third equation is defining the parameter branch for a pair of buses that are connected (conex(bus,node) is true) and a parameter called bij.
It is saying that the value of branch(bus,node,'x') should be set to 1 divided by the value of bij.


-------------------------------------------------------------
Using the table below

Table branch(bus,node,*) 'network technical characteristics'
        x     Limit
   1.2  0.2   100
   2.3  0.25  100
   1.3  0.4   100 ;
   
We get:


                           LOWER          LEVEL          UPPER         MARGINAL

---- VAR OF                -INF         1035.0000        +INF             .  



      Gen(MW)       Angle    load(MW)  LMP($/MWh)

1      65.000       0.020                  11.000
2                  -0.100     100.000      11.000
3      35.000                              11.000





-------------------------------------------------------------


-----------------------------------------------------------
Question: What would happen if the flow limit of the branch connecting bus 1 to
bus 2 is reduced to 50MW.

Table branch(bus,node,*) 'network technical characteristics'
        x     Limit
   1.2  0.2   50
   2.3  0.25  100
   1.3  0.4   100 ;

We get:



                           LOWER          LEVEL          UPPER         MARGINAL

---- VAR OF                -INF         1056.2500        +INF             .



      Gen(MW)       Angle    load(MW)  LMP($/MWh)

1      43.750      -0.025                  10.000
2                  -0.125     100.000      11.625
3      56.250                              11.000



            1           2           3

1                   0.500      -0.062
2      -0.500                  -0.500
3       0.062       0.500

------------------------------------------------------------

**************************************************************
$offText
branch(bus,node,'x')$(branch(bus,node,'x')=0)         =   branch(node,bus,'x');
branch(bus,node,'Limit')$(branch(bus,node,'Limit')=0) =   branch(node,bus,'Limit');
branch(bus,node,'bij')$conex(bus,node)                = 1/branch(bus,node,'x');
*****************************************************

Variable OF, Pij(bus,node), Pg(Gen), delta(bus);
Equation const1, const2, const3;

***********************************************************************
const1(bus,node)$(conex(bus,node))..
   Pij(bus,node) =e= branch(bus,node,'bij')*(delta(bus) - delta(node));

const2(bus)..
   sum(Gen$GBconect(bus,Gen), Pg(Gen)) - BusData(bus,'pd')/Sbase =e= sum(node$conex(node,bus), Pij(bus,node));

const3..
   OF =g= sum(Gen,Pg(Gen)*GenData(Gen,'b')*Sbase);

Model loadflow / const1, const2, const3 /;

Pg.lo(Gen) = GenData(Gen,'Pmin')/Sbase;
Pg.up(Gen) = GenData(Gen,'Pmax')/Sbase;

delta.up(bus)   = pi;
delta.lo(bus)   =-pi;
delta.fx(slack) = 0;

Pij.up(bus,node)$((conex(bus,node))) = 1*branch(bus,node,'Limit')/Sbase;
Pij.lo(bus,node)$((conex(bus,node))) =-1*branch(bus,node,'Limit')/Sbase;
solve loadflow minimizing OF using lp;

Parameter report(bus,*), Congestioncost;
report(bus,'Gen(MW)')    = sum(Gen$GBconect(bus,Gen), Pg.l(Gen))*sbase;
report(bus,'Angle')      = delta.l(bus);
report(bus,'load(MW)')   = BusData(bus,'pd');
report(bus,'LMP($/MWh)') = const2.m(bus)/sbase;
Congestioncost = sum((bus,node), Pij.l(bus,node)*(-const2.m(bus) + const2.m(node)))/2;
display report, Pij.l, Congestioncost;
