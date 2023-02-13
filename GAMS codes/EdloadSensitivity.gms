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



Set Gen /g1*g5/
    counter /c1*c11/;
 

Parameter report(counter, *);
Parameter repGen(counter, Gen);


Scalar load /400/;


Table data(Gen,*)

       a     b      c       d     e         f      Pmin  Pmax
   g1  3     20     100     2     -5        3      28    206
   g2  4.05  18.07  98.87   3.82  -4.24     6.09   90    284
   g3  4.05  15.55  104.26  5.01  -2.15     5.69   68    189
   g4  3.99  19.21  107.21  1.10  -3.99     6.2    76    266
   g5  3.88  26.18  95.31   3.55  -6.88     5.57   19    53;

Variable P(gen), OF;
Equation eq1, eq2;

eq1 .. OF =e= sum(gen, data(gen,'a')*P(gen)*P(gen) + data(gen,'b')*P(gen) + data(gen,'c'));
eq2 .. sum(gen,P(gen)) =g= load;

P.lo(gen)=data(gen, 'Pmin');
P.up(gen) =data(gen, 'Pmax');

Model ECD /eq1, eq2/;

loop(counter,
load = sum(gen, data(gen,'Pmin')) + ((ord(counter)-1)/(card(counter)-1))*sum(gen, data(gen,'Pmax')-data(gen,'Pmin'));
Solve ECD using qcp minimizing OF;

repGen(counter, Gen) = P.l(gen);
report(counter,'OF') = OF.l;
report(counter,'load') = load;
);

display repGen, report;

*=== Export to Excel using GDX utilities

*=== First unload to GDX file (occurs during execution phase)
execute_unload "Edload.gdx" repGen report

*=== Now write to variable levels to Excel file from GDX 
*=== Since we do not specify a sheet, data is placed in first sheet
*execute 'gdxxrw.exe results.gdx o=results.xlsx var=x.L'

*=== Write marginals to a different sheet with a specific range
*execute 'gdxxrw.exe  results.gdx o=results.xlsx var=x.M rng=NewSheet!f1:i4'




$onText

--------------------------------
Code explanation

This code is written in GAMS (General Algebraic Modeling System) and implements an Economic Dispatch (ECD) problem.

The ECD problem aims to determine the optimal power generation of multiple power plants to meet a certain load demand,
while minimizing the total cost of generation.

The first part of the code declares sets, parameters, tables, variables, and equations used in the model.

The sets "Gen" and "counter" represent the power plants and the number of iterations, respectively.

The "data" table contains information about each power plant, such as its minimum and maximum power output, and various coefficients.

The "P" variable represents the power output of each power plant, and the "OF" variable represents the objective function,

which is the total cost of power generation.

The "eq1" equation defines the objective function,

and the "eq2" equation enforces the constraint that the total power output of all plants must equal the load demand.

In the next part of the code, a loop is created over the counter set to iterate the solution process.

The load demand is increased in each iteration by a factor determined by the current iteration number and the total number of iterations.

The "Solve" statement is used to solve the model with the "min of" option to minimize the objective function.

The results are stored in the "repGen" and "report" parameters, which are then displayed at the end of the code.

In summary, this code solves an Economic Dispatch problem by iteratively increasing the load demand and

finding the optimal power generation of multiple power plants that minimizes the total cost of generation.

-------------------------------


-------------------------------
A numerical explanation of the loop section of the code



The loop section of the code is a loop that runs 11 times. Each time the loop runs, it updates the load variable and solves the optimization problem.

The optimization problem minimizes the objective function "OF",
which is a sum of the products of the data values "a", "b", and "c" with the power output of each generator "P(gen)".

The power output of each generator must also satisfy the constraint that the total power output must equal the load.

The loop starts by setting the load to the minimum power output possible from all the generators.

Then, in each iteration of the loop, the load is gradually increased so that it approaches the maximum power output possible from all the generators.

The load for each iteration is calculated as the sum of the minimum power output of all

the generators plus a fraction of the difference between the maximum and minimum power outputs of all the generators.

The fraction is calculated as the current iteration number divided by the total number of iterations (11), minus one.

At the end of each iteration, the results of the optimization problem, including the optimal power output for each generator "P.l(gen)" and the objective function value "OF.l",

 are stored in the variables "repGen" and "report". The results of each iteration are then displayed after all 11 iterations have completed.
 
Let's consider a numerical example to understand the first and 10th iteration of the loop. Suppose the minimum power output of all generators is 100, and the maximum power output is 1000. The loop will run 11 times, so the load will gradually increase from 100 to 1000.

For the first iteration, the load will be set to 100 + ((1-1)/(11-1)) * (1000-100) = 100 + (0) * (900) = 100.

For the 10th iteration, the load will be set to 100 + ((10-1)/(11-1)) * (1000-100) = 100 + (9/10) * (900) = 100 + 810 = 910.

In each iteration, the optimization problem is solved to find the optimal power output of each generator that satisfies the constraint and minimizes the objective function.

The results of the optimization problem, including the optimal power output of each generator and the objective function value, are stored in the variables "repGen" and "report".

These values will be different for each iteration as the load changes.

------------------------------












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
