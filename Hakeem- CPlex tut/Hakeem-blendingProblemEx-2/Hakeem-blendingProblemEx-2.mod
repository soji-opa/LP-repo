/*********************************************
 * OPL 22.1.0.0 Model
 * Author: User
 * Creation Date: 29 Nov 2022 at 12:15:21
 *********************************************/
// The blending problem

// Declaring indexes
{int} Raw_Material = {1,2,3,4,5};
{int} Productionline = {1,2};

//Declare Data

int capacity[Productionline]=[200,250];
int unitcost[Raw_Material] = [110,120,130,110,115];
int unitprice = 150;
float RMhardness[Raw_Material] = [8.8, 6.1, 2.0, 4.2, 5.0];
int minFPhardness = 3; //minimum finished product hardness
int maxFPhardness = 6; // maximimum finished product hardness

// Decision varibales
dvar float+  RMqty[Raw_Material]; // variable x
dvar float+ FPqty; // variable y

// Objective function 

dexpr float profit = unitprice * FPqty - sum(i in Raw_Material) unitcost[i]*RMqty[i];

// Model

maximize profit;

//constraint expression 
// forall(j in Productionline:j==1)
//	  Capacity_Constraint1: sum(i in Raw_Material:i<=2) RMquantity[i]<=capacity[j];
//	
//	forall(j in Productionline:j==2)
//	  Capacity_Constraint2: sum(i in Raw_Material:i>2) RMquantity[i]<=capacity[j];
//	
//	 Hardness_constraint1: sum(i in Raw_Material) RMhardness[i]*RMquantity[i]-minFPhardness*FPquantity>=0;
//	 
//	 Hardness_constraint2: sum(i in Raw_Material) RMhardness[i]*RMquantity[i]-maxFPhardness*FPquantity<=0;
//
//	Weight_Equality: sum(i in Raw_Material) RMquantity[i] - FPquantity==0;
// forall(j in Productionline:j==1)
//    Capacity_Constraint1:
//    sum(i in Raw_Material:i<=2) RMqty[i]<=capacity[j];
//  	//RMqty[1] + RMqty[2] <= capacity[j];
//
//  forall(j in Productionline:j==2)
//    Capacity_Constraint2:
//    sum(i in Raw_Material:i>2) RMqty[i]<=capacity[j];
//    //RMqty[3] + RMqty[4] + RMqty[5] <= capacity[j];
//  
//  Hardness_constraint1:
//  sum(i in Raw_Material) RMhardness[i] * RMqty[i] - minFPhardness*FPqty <= 0;
//  
//  Hardness_constraint2: 
//  sum(i in Raw_Material) RMhardness[i]*RMqty[i]-maxFPhardness*FPqty<=0;
//  
//  Weight_Equality:
//  sum(i in Raw_Material) RMqty[i] - FPqty==0;

subject to{
 forall(j in Productionline:j==1)
	  Capacity_Constraint1: 
//	  sum(i in Raw_Material:i<=2) RMqty[i]<=capacity[j];
	  RMqty[1] + RMqty[2] <= capacity[j];
	
	forall(j in Productionline:j==2)
	  Capacity_Constraint2: 
	  sum(i in Raw_Material:i>2) RMqty[i]<=capacity[j];
	
	 Hardness_constraint1: 
	 sum(i in Raw_Material) RMhardness[i]*RMqty[i]-minFPhardness*FPqty>=0;
	 
	 Hardness_constraint2: 
	 sum(i in Raw_Material) RMhardness[i]*RMqty[i]-maxFPhardness*FPqty<=0;

	Weight_Equality: 
	sum(i in Raw_Material) RMqty[i] - FPqty==0;
}

// Post Processing
execute {
	if(cplex.getCplexStatus()==1){ /* Calling the function "getCplexStatus()" equal "1" means  
                                         if problem have optimum solution*/
	for (var i in Raw_Material)
		writeln("Reduced cost of Raw Material-" ,i, "=",RMqty[i].reducedCost);
		writeln("Reduced cost of Final Product =" ,FPqty.reducedCost);
		for (var j in Productionline){
		if(j==1){
		writeln("Dual of Capacity_Constraint1 is ",j,Capacity_Constraint1[j].dual);
		}
		if(j==2)
		{
		writeln("Dual of Capacity_Constraint2 is ",j,Capacity_Constraint2[j].dual);
		}
		}
		writeln("Dual of Hardness_constraint1 is ",Hardness_constraint1.dual);	
		writeln("Slack of Hardness_constraint1 is ",Hardness_constraint1.slack);	
		writeln("Dual of Hardness_constraint2 is ",Hardness_constraint2.dual);
		writeln("Slack of Hardness_constraint2 is ",Hardness_constraint2.slack);
		writeln("Dual of Weight_Equality is ",Weight_Equality.dual);
	}else{
	writeln("Error: Solution not found");	
	}
}
