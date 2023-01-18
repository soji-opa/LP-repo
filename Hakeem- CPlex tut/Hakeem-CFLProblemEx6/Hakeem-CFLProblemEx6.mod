/*********************************************
 * OPL 22.1.0.0 Model
 * Author: naruto
 * Creation Date: Dec 6, 2022 at 8:24:30 AM
 *********************************************/
// Indices
int supp_region=...; range SR=1..supp_region;// index i
int dem_region=...; range DR=1..dem_region;// index j
// Parameters
int fixcost[SR]=...;
int capacity[SR]=...;
int demand[DR]=...;
int transp_cost[SR][DR]=...;
// Decision Variables
dvar float+ Q[SR][DR];
dvar boolean y[SR];
dexpr float Totalcost=sum(i in SR, j in DR)Q[i][j]*transp_cost[i][j]+
				 sum(i in SR)y[i]*fixcost[i];
minimize Totalcost;
subject to{
	forall(j in DR)
	  sum(i in SR)Q[i][j]==demand[j];
	  
	forall(i in SR)
	  sum(j in DR)Q[i][j]<=capacity[i]*y[i];	    
}