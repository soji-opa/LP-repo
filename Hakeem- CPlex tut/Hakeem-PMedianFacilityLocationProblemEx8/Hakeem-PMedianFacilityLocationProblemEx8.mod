/*********************************************
 * OPL 22.1.0.0 Model
 * Author: naruto
 * Creation Date: Jan 24, 2023 at 12:35:43 PM
 *********************************************/

//main{
//	// Generating & Solving initial model
//	thisOplModel.generate(); // Generating the current model instance
//		if (cplex.solve())
//		{
//		//var ofile = new IloOplOutputFile("E:/4. MS-Industrial Engineering & Management/1. Advanced Operations Research (Session 2019-2021)/AOR (Lab)/3. P-Median-Problem/Answer.txt");
//  		//ofile.writeln(thisOplModel.printSolution());
//  		//ofile.writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex.getCplexTime());
//  		//ofile.close();
//		var obj = cplex.getObjValue();
//		writeln("The Value of the Objective Function Value is (Total Weighted Distance): ", obj);
//		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex.getCplexTime()); 
//		thisOplModel.postProcess(); 
//		}
//	else {
//			writeln("No Solution");	
//		 } 
//}
//  This is the model I wrote, doesn't give perfect results. As the third constraint doesn't seem to hold
 
// //indices
// {string} Warehouses =...; //j (facility)
// {string} Customers = ...; // i
// 
// //parameters and data
// int MaxWarehousesP =...;
// float Demand[Customers]=...;
// float Distance[Warehouses][Customers] =...;
// 
// //Decision Variables
// dvar boolean Open[Warehouses];
// dvar boolean Assign[Warehouses][Customers];
// 
// //OF & Model
// 
// minimize sum(i in Customers, j in Warehouses) Distance[i][j]*Assign[i][j]*Demand[i];
// 
// subject to{
//   forall (i in Customers)
//     EachCustomerdemandmustbemet:
//     	sum(j in Warehouses) Assign[i][j] ==1;
//     	
//    Maximumnooffacilities:
//    	sum(j in Warehouses) Open[j] == MaxWarehousesP;
//    	
//    forall(i in Customers, j in Warehouses)
//      Customermustbeassignedtoopenfacility:
//      	Assign[i][j] <= Open[j];
//}
 
 //This is Dr Hakeem Rehman's model, with my own indices'
 // indicies
//{string} Warehouses =...;  
//{string} Customers =...;  
//
//// Parameters and Data
//int MaxWarehousesP =...;  
//float Demand[Customers] =...;  
//float Distance[Warehouses][Customers]=...;  
//
//// Decision Variables
//dvar boolean Open[Warehouses];  
//dvar boolean Assign[Warehouses][Customers];  
//
//// Model 
//
//// Total demand weighted distance
//minimize  sum(j in Warehouses, i in Customers) Distance[j][i]*Demand[i]*Assign[j][i]; 
//    
//subject to{
//
//  forall ( i in Customers) 
//    EachCustomersDemandMustBeMet:
//    	sum( j in Warehouses ) Assign[j][i]==1;	
//  
//    UseMaximum_P_Warehouses:
//  	sum(j in Warehouses) Open[j]==MaxWarehousesP;
//  
//    forall (j in Warehouses, i in Customers)
//    CannotAssignCustomertoWH_UnlessItIsOpen:
//      Assign[j][i] <= Open[j];
//}
 
 //This is Dr Rehamn's model with his own index'
 // indicies
{string} Warehouses =...;  
{string} Customers =...;  

// Parameters and Data
int MaxWarehousesP =...;  
float Demand[Customers] =...;  
float Distance[Warehouses][Customers]=...;  

// Decision Variables
dvar boolean Open[Warehouses];  
dvar boolean Assign[Warehouses][Customers];  

// Model 

// Total demand weighted distance
minimize  sum(w in Warehouses, c in Customers) Distance[w][c]*Demand[c]*Assign[w][c]; 
    
subject to{

  forall ( c in Customers) 
    EachCustomersDemandMustBeMet:
    	sum( w in Warehouses ) Assign[w][c]==1;	
  
    UseMaximum_P_Warehouses:
  	sum(w in Warehouses) Open[w]==MaxWarehousesP;
  
    forall (w in Warehouses, c in Customers)
    CannotAssignCustomertoWH_UnlessItIsOpen:
      Assign[w][c] <= Open[w];
}
 
 
 
 
 