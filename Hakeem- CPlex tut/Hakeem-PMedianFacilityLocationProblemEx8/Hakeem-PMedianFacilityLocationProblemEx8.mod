/*********************************************
 * OPL 22.1.0.0 Model
 * Author: naruto
 * Creation Date: Jan 24, 2023 at 12:35:43 PM
 *********************************************/

main{
	// Generating & Solving initial model
	thisOplModel.generate(); // Generating the current model instance
		if (cplex.solve())
		{
		//var ofile = new IloOplOutputFile("E:/4. MS-Industrial Engineering & Management/1. Advanced Operations Research (Session 2019-2021)/AOR (Lab)/3. P-Median-Problem/Answer.txt");
  		//ofile.writeln(thisOplModel.printSolution());
  		//ofile.writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex.getCplexTime());
  		//ofile.close();
		var obj = cplex.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Weighted Distance): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex.getCplexTime()); 
		thisOplModel.postProcess(); 
		}
	else {
			writeln("No Solution");	
		 } 
}
 
 //indices
 {string} Warehouses =...; //j (facility)
 {string} Customers = ...; // i
 
 //parameters and data
 int MaxWarehousesP =...;
 float Demand[Customers]=...;
 float Distance[Warehouses][Customers] =...;
 
 //Decision Variables
 dvar boolean Open[Warehouses];
 dvar boolean Assign[Customers][Warehouses];
 
 //OF & Model
 
 minimize sum(i in Customers, j in Warehouses) Distance[i][j]*Assign[i][j]*Demand[i];
 
 subject to{
   forall (i in Customers)
     EachCustomerdemandmustbemet:
     	sum(j in Warehouses) Assign[i][j] ==1;
     	
    Maximumnooffacilities:
    	sum(j in Warehouses) Open[j] == MaxWarehousesP;
    	
    forall(i in Customers, j in Warehouses)
      Customermustbeassignedtoopenfacility:
      	Assign[i][j] <= Open[j];
}
 
 
 
 
 
 
 