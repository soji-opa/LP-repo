$title Pareto optimal front determination

$onText
For more details please refer to Chapter 2 (Gcode2.16), of the following book:
Soroudi, Alireza. Power System Optimization Modeling in GAMS. Springer, 2017.
--------------------------------------------------------------------------------
Model type: NLP
--------------------------------------------------------------------------------
Contributed by
Dr. Alireza Soroudi
IEEE Senior Member
email: alireza.soroudi@gmail.com
We do request that publications derived from the use of the developed GAMS code
explicitly acknowledge that fact by citing
Soroudi, Alireza. Power System Optimization Modeling in GAMS. Springer, 2017.
DOI: doi.org/10.1007/978-3-319-62350-4

Course: Mastering Energy & PSO in GAMS {Udemy}

Student: Azeez Olasoji


$offText

Variable of1, of2, x1, x2;
Equation eq1, eq2, eq3, eq4;

eq1.. 4*x1 - 0.5*sqr(x2) =e= of1;
eq2.. -sqr(x1) + 5*x2    =e= of2;
eq3.. 2*x1 + 3*x2        =l= 10;
eq4.. 2*x1 -   x2        =g=  0;

x1.lo = 1; x1.up = 2;
x2.lo = 1; x2.up = 3;

Model pareto1 / all /;

Set counter / c1*c21 /;
Scalar E;
Parameter report(counter,*), ranges(*);

*from the pareto curve, where do we find/place our minimum values
*The trick is when of1 is max, of2 is at the min val & vice versa

solve pareto1 using nlp maximizing of1;
ranges('OF1max') = of1.l;
ranges('OF2min') = of2.l;

solve pareto1 using nlp maximizing of2;
ranges('OF2max') = of2.l;
ranges('OF1min') = of1.l;

loop(counter,
   E = (ranges('OF2max') - ranges('OF2min'))*(ord(counter) - 1)/(card(counter) - 1) + ranges('OF2min');
   of2.lo = E;
   solve pareto1 using nlp maximizing of1;
   report(counter,'OF1') = of1.l;
   report(counter,'OF2') = of2.l;
   report(counter,'E')   = E;
);
display report;

$onText
This code is solving a multi-objective optimization problem, known as the Pareto front problem. In this problem, the goal is to find a set of solutions that represent the trade-off between multiple objective functions.

The objective functions in this code are of1 and of2, which are defined as expressions in the Equations eq1 and eq2 respectively. Equation eq3 and eq4 represent constraints that need to be satisfied by the solutions.

The code sets lower and upper bounds for the variables x1 and x2 and defines a model called "pareto1" with all the equations and constraints.

A set of 21 solutions is generated through a loop, where the value of a scalar "E" is changed, and the optimization problem is solved twice: once maximizing of1 and once maximizing of2. The results of the optimization are stored in the parameter "report". The value of "E" is used to set the lower bound of the objective function of2. T
he final results are displayed using the "display" command.


---------------------------------
The code in the loop
---------------------------------

This code is solving a multi-objective optimization problem, known as the Pareto front problem. In this problem, the goal is to find a set of solutions that represent the trade-off between multiple objective functions.

The objective functions in this code are of1 and of2, which are defined as expressions in the Equations eq1 and eq2 respectively. Equation eq3 and eq4 represent constraints that need to be satisfied by the solutions.

The code sets lower and upper bounds for the variables x1 and x2 and defines a model called "pareto1" with all the equations and constraints.

A set of 21 solutions is generated through a loop, where the value of a scalar "E" is changed, and the optimization problem is solved twice: once maximizing of1 and once maximizing of2. The results of the optimization are stored in the parameter "report". The value of "E" is used to set the lower bound of the objective function of2. The final results are displayed using the "display" command.




olasoji opa
explain the code in the loop and give numerical examples please
The code in the loop defines the main logic for creating the Pareto Front. Here's how it works step by step:

The variable "E" is defined as a scalar and is used to keep track of the value of the second objective function "of2".

The variable "ranges" is a parameter defined with two elements, "OF2min" and "OF2max". "OF2min" and "OF2max" are the minimum and maximum values of the second objective function "of2". These values are determined in two separate "solve" statements outside the loop, by solving the model "pareto1" using NLP (Non-Linear Programming) and maximizing "of1" and "of2" respectively.

The loop starts with the counter set to "c1" and continues until it reaches "c21".

In each iteration of the loop, the value of "E" is calculated using the following formula:

E = (ranges('OF2max') - ranges('OF2min')) * (ord(counter) - 1) / (card(counter) - 1) + ranges('OF2min');

Here, ord(counter) is the current iteration number of the loop and card(counter) is the total number of iterations (21). So, in the first iteration, ord(counter) would be 1 and in the last iteration, it would be 21.

The formula calculates the value of "E" as a linear function of the difference between the maximum and minimum values of "of2". This formula is used to generate a range of values of "E" between the minimum and maximum values of "of2".

In each iteration, the lower bound of "of2" is set to the current value of "E". The model "pareto1" is then solved again using NLP and maximizing "of1".

The values of "OF1", "OF2", and "E" are then added to the "report" parameter to keep track of the results.

The loop continues until it has completed all 21 iterations.

Here's an example:

Suppose in the first two solves, the values of "OF2min" and "OF2max" are determined to be 1 and 5 respectively.

In the first iteration, "E" would be calculated as:

E = (5 - 1) * (1 - 1) / (21 - 1) + 1 = 1

The lower bound of "of2" would be set to 1 and the model "pareto1" would be solved again with "of1" as the objective. The values of "OF1", "OF2", and "E" would be recorded in the "report" parameter.

In the second iteration, "E" would be calculated as:

E = (5 - 1) * (2 - 1) / (21 - 1) + 1 = 2

The lower bound of "of2" would be set to 2 and the model "pareto1" would be solved again with "of1" as the objective. The values of "OF1", "OF2", and "E" would be recorded in the "report" parameter again.

This process continues until all 21 iterations are completed, generating a set of 21 different solutions on the Pareto Front.
