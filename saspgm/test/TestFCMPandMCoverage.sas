/**
   \file 
   \brief Testcase for MCOVERAG and PROC FCMP
*/
/** \cond */
%macro TestFCMPandMCoverage;
   proc FCMP;
      subroutine move (i , a $, b $, c $);
          if (i > 0) then do;
             call move (i-1, a, c, b);
             put "Move disk" i z2. "from" a "to" c;
             call move (i-1, b, a, c);
          end;
      endsub;
      call move (3,"A","B","C");
   run;
%mend TestFCMPandMCoverage;


%macro TestFCMPandMCoverage1;   
   proc FCMP outlib=WORK.TESTMCOVERAGE.SASUnit;
      subroutine move (i , a $, b $, c $);
          if (i > 0) then do;
             call move (i-1, a, c, b);
             put "Move disk" i z2. "from" a "to" c;
             call move (i-1, b, a, c);
          end;
      endsub;
   run;

   options cmplib=WORK.TESTMCOVERAGE;
   data _null_;
      call move (4,"A","B","C");
   run;
%mend TestFCMPandMCoverage1;

%macro Gest_VarianceFormulaType ;

   /* Remove quotes from expected parameters to FCMP function */
   %let SampleFile     = %qsysfunc(dequote(&SampleFile));
   %let SamplingUnitID = %qsysfunc(dequote(&SamplingUnitID));
   %let CountLevelID   = %qsysfunc(dequote(&CountLevelID));

      %if (&SamplingUnitID eq &CountLevelID) %then
          %let FormulaType = 1;
      %else
          %let FormulaType = 2;

%mend Gest_VarianceFormulaType;
/** \endcond */
