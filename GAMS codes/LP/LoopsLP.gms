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

$onText

This code calculates a value for the scalar "E" in each iteration of the loop. The formula used is:

E = -2 + 7 * (ord(counter) - 1) / (card(counter) - 1)

where:

ord(counter) is the index of the counter, starting from 1.
card(counter) is the total number of elements in the set "counter".
The value of E is calculated by first subtracting 1 from ord(counter) and then dividing the result by card(counter) - 1. This gives a fraction between 0 and 1. Then 7 is multiplied with this fraction to get a value between 0 and 7.
Finally, this value is added to -2 to get the final value of E.

The purpose of this expression is to change the value of E from -2 to +5 over the iterations of the loop,
with the initial E being -2 and the last E being +2.
The exact behavior of this expression would depend on the values assigned to the set "counter".

This line of code calculates a new value for the scalar E at each iteration of the loop. Here's how it works:

First, E is initialized to -2.
At each iteration of the loop, the value of counter changes.
The ord(counter) function returns the index of counter in the set counter. For example, if counter = c1, ord(counter) will return 1.
ord(counter) is subtracted by 1 to give a value that ranges from 0 to card(counter)-1, where card(counter) returns the number of elements in the set counter.
The expression 7*(ord(counter)-1)/(card(counter)-1) calculates a fraction between 0 and 7, which is then added to -2.
The result is stored in E.
This process repeats for each iteration of the loop until all elements in the set counter have been processed.
The effect of this line of code is that the value of E changes linearly from -2 to +5 over the course of the loop iterations.

$offText