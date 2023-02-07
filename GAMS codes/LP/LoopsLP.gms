$onText

set i /1 * 4/;

Variable x(i), OF;

Equation eq1, eq2, eq3;


x.lo(i) = -2;
x.up(i) = 2;

eq1 .. 1=e= sum(i $(ord(i) <> 4), x(i));
eq2 .. 2=l= sum(i $(ord(i) <> 3), x(i));
eq3 .. OF =e= sum(i, x(i))

Model soji /all/;

solve soji min OF using LP

$offText

$onText

In the event that I want to change eq2 {the value of 2, to a range btwn -1 & +5}
to see how this values influence the variable values & the obj fnc, I'd use a loop
with the code shown below

$offText

set i /1 * 4/;

Variable x(i), OF;

Equation eq1, eq2, eq3;

Scalar E /2/;


x.lo(i) = -2;
x.up(i) = 2;

eq1 .. 1=e= sum(i $(ord(i) <> 4), x(i));
eq2 .. E=l= sum(i $(ord(i) <> 3), x(i));
eq3 .. OF =e= sum(i, x(i))

Model soji /all/;

solve soji min OF using LP;

set counter /c1 *c5/;
Parameter report (counter, *);

loop(counter,

* Now, I want to write down an expression that chnages the value of E from -2 to +5
* with the initial E being -2 & the last E being +2
E = -2 + 7*(ord(counter)-1)/(card (counter)-1);


solve soji min OF using LP;


* So the thing is we need a much more sophisticated way of viewing the result in the loop
* Thus we created a parameter report, with the counter data we created and
*we decided to print the OF & the scalar values

*Note we use .l for the OF because it is a variable and we want to see the lower value of it
* However, for E, it is not needed because it is a scalar and the value changes.


report (counter, 'OF')=OF.l;
report (counter, 'E')=E;

);

display report;