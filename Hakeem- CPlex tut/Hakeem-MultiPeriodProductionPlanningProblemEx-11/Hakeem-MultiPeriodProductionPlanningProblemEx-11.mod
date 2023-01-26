/*********************************************
 * OPL 22.1.0.0 Model
 * Author: naruto
 * Creation Date: Jan 26, 2023 at 6:43:09 PM
 *********************************************/
// TO START UP A CODE, IDENTIFY THE INDICES

// Indices
{string} Products = ...;
{string} Resources = ...;
int NbPeriods = ...; range Periods = 1..NbPeriods;

// Parameters and Data
float Consumption[Resources][Products] = ...;
float Capacity[Resources] = ...;
float Demand[Products][Periods] = ...;
float InsideCost[Products] = ...;
float OutsideCost[Products] = ...;
float Inventory[Products] = ...;
float InvCost[Products] = ...;

// Decision Variables
dvar float+ Inside[Products][Periods];
dvar float+ Outside[Products][Periods];
dvar float+ Inv[Products][0..NbPeriods];

// Objective Function
minimize sum(p in Products, t in Periods) (InsideCost[p]*Inside[p][t] + OutsideCost[p]*Outside[p][t] + InvCost[p]*Inv[p][t]);

subject to {
	forall(r in Resources, t in Periods)
	ctCapacity:
		sum(p in Products) Consumption[r][p] * Inside[p][t] <= Capacity[r];

	forall(p in Products , t in Periods)
	ctDemand:
		Inv[p][t-1] + Inside[p][t] + Outside[p][t] == Demand[p][t] + Inv[p][t];

	forall(p in Products)
	ctInventory:
		Inv[p][0] == Inventory[p];
	}

// Use Postprocessing execute blocks to display the output data
//tuple plan {
//	float inside;
//	float outside;
//	float inv;
//}
//plan Plan[p in Products][t in Periods] = <Inside[p,t],Outside[p,t],Inv[p,t]>;
//
//execute{
//	writeln("Current Plan = ",Plan);
//}