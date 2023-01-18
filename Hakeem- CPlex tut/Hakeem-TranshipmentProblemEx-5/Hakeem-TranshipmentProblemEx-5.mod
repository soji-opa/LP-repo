/*********************************************
 * OPL 22.1.0.0 Model
 * Author: naruto
 * Creation Date: Dec 6, 2022 at 7:51:13 AM
 *********************************************/
//INDEX
{int} plants = {1,2};        //i
{int} centres = {1,2};      //k
{int} regions = {1,2,3};    //j

//PARAMETERS & DATA
int unitcostPTC[plants][centres]= ...; //[[190,210],[185,205]];
int unitcostCTR[centres][regions]= ...; //[[175,180,165],[235,130,145]];
int supply[plants]= ...; //[150,180]; supply of the plants
int demand[regions]= ...; //[38,145,120]; quantity demanded by the regions

//DECISION VARIABLES
dvar float+ shippedQPTC[plants][centres];// i.e. x(ik)
dvar float+ shippedQCTR[centres][regions]; //i.e. x(kj)

//OBJECTIVE FUNCTION
dexpr float transpcost= sum(i in plants, k in centres) shippedQPTC[i][k]*unitcostPTC[i][k]
						+ sum(k in centres, j in regions) unitcostCTR[k][j]*shippedQCTR[k][j];

// MODEL
minimize transpcost;
subject to{

DEMANDCONS:
forall(j in regions)
	sum(k in centres) shippedQCTR[k][j]==demand[j];

FLOWCONSERVATIONCONS:
forall(k in centres)
 	sum(i in plants) shippedQPTC[i][k]== sum(j in regions) shippedQCTR[k][j];
  
SUPPLYCONS:
 forall(i in plants)
    sum(k in centres) shippedQPTC[i][k]<=supply[i];
}
 