/*********************************************
 * OPL 22.1.0.0 Model
 * Author: User
 * Creation Date: 29 Nov 2022 at 11:14:47
 *********************************************/
// Definde the decision vairiables

dvar float+ x;
dvar float+ y;

// Write out the objective funvtion
dexpr float cost =  0.12* x + 0.15*y; 

//Model

minimize cost;

// declaring constraints

subject to{
  const1:
  60*x + 60*y >= 300;
  
  const2:
  12*x + 6*y >= 36;
  
  const3:
  10*x + 30*y >= 90;
}

//sensitivity analysis

//post processing

execute{
  if(cplex.getCplexStatus()==1){ // calling the function "getCplexStatus()" equal "1" implies if
  								// the probelem has an optimal solution, do the ffg
    
    writeln("Reduced cost of 'x'=", x.reducedCost);
    writeln("Reduced cost of 'y'=", y.reducedCost);
    writeln("Dual of constraint-1 is =", const1.dual);
    writeln("Dual of constraint-2 is =", const2.dual);
    writeln("Dual of constraint-3 is =", const3.dual);
  }else{
    writeln("Error: Solution not found")
  }
}