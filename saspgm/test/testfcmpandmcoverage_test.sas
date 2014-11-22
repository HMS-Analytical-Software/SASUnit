/** 
  \file
  \brief Test Scenario for MCOVERAGE and FCMP, will always be run because macro Gest_VarianceFormulaType is generated on the fly

*/
/** \cond */

%initTestcase (i_object=TestFCMPandMCoverage.sas, i_desc=Checking MCOVERAGE and simple PROC FCMP call);
%TestFCMPandMCoverage;
%endTestCall;
%assertLog (i_errors=0, i_warnings=0);
%endTestcase;

%initTestcase (i_object=TestFCMPandMCoverage.sas, i_desc=Checking MCOVERAGE and PROC FCMP with PROC FCMP-path);
%TestFCMPandMCoverage1;
%endTestCall;
%assertLog (i_errors=0, i_warnings=0);
%assertLogMsg(i_logMsg=Move disk 04 from A to C);
%endTestcase;

data data;
   city=1; prov=1; m1=.; m2=.; m3=.; cidx=1; eidx=1; sex=1; cid=1; eid=11;x1=1; sw=11; output;
   city=1; prov=1; m1=.; m2=.; m3=.; cidx=1; eidx=1; sex=1; cid=1; eid=12;x1=2; sw=11; output;
   city=1; prov=1; m1=.; m2=.; m3=.; cidx=1; eidx=1; sex=1; cid=2; eid=21;x1=3; sw=12; output;
   city=1; prov=1; m1=.; m2=.; m3=.; cidx=1; eidx=1; sex=1; cid=2; eid=22;x1=4; sw=12; output;
   city=1; prov=2; m1=.; m2=.; m3=.; cidx=1; eidx=1; sex=1; cid=3; eid=31;x1=5; sw=13; output;
   city=1; prov=2; m1=.; m2=.; m3=.; cidx=1; eidx=1; sex=1; cid=3; eid=32;x1=6; sw=13; output;
   city=1; prov=2; m1=.; m2=.; m3=.; cidx=1; eidx=1; sex=1; cid=4; eid=41;x1=7; sw=14; output;
   city=1; prov=2; m1=.; m2=.; m3=.; cidx=1; eidx=1; sex=1; cid=4; eid=42;x1=8; sw=14; output;
run;
proc fcmp outlib=work.Gest_Functions.SASUnit;
   /* Find the type of formula to use for the levels of Variance */
   function VarianceFormulaType(SampleFile $,SamplingUnitID $,CountLevelID $) $;
      length FormulaType $ 1;
      rc = run_macro('Gest_VarianceFormulaType',SampleFile,SamplingUnitID,CountLevelID,FormulaType);
      return(FormulaType);
   endsub;
run; /* proc fcmp */

options cmplib=work.Gest_Functions;

/*-- Standard case 0--------------------------------------*/
%initTestcase(i_object=%str(Gest_VarianceFormulaType.sas),
i_desc=%str(Standard case 0: VarianceFormulaType 1));
%let SamplingUnitID=%quote(cid eid);
%let CountLevelID=%quote(cid eid);
%let MCOVERAGE=%sysfunc (getoption(MCOVERAGE));
options nomcoverage;
data _null_;
   call symput ("FormulaType", VarianceFormulaType("work.data","&SamplingUnitID","&CountLevelID"));
run;
options &mcoverage.;

%assertEquals(i_actual=&FormulaType. , i_expected=1, i_desc=Return Code);
%endTestcase();
/** \endcond */
