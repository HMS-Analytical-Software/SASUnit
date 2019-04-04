/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _asserts.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _asserts.sas);

/* save values from original scenario */
%let save_g_scnid = &g_scnid.;
%let save_target  = %sysfunc (pathname(target));
libname target "&save_target.";
data work.cas;
   set target.cas;   
   stop;
run;
data work.tst;
   set target.tst;   
   stop;
run;
proc sql noprint;
   insert into work.cas values (999,999,0,"","","",.,.,.);
   insert into work.tst values (999,999,998,"","","","",.,"");
quit;
data work.expected_cas;
   set work.cas;
   cas_res=0;
run;


%initTestcase(i_object=_asserts.sas, i_desc=Test with result 0)
data work.expected_tst;
   set work.tst;
   output;
   tst_id=999;
   tst_type="assertEquals";
   tst_exp="Hugo";
   tst_act="Fritz";
   tst_desc="Keine";
   tst_res=0;
   tst_errmsg="assertEquals: assert passed.";
   output;
run;
%let g_scnid=999;
libname target (work);
%_asserts(i_type     = assertEquals      
         ,i_expected = Hugo
         ,i_actual   = Fritz      
         ,i_desc     = Keine      
         ,i_result   = 0  
         );

libname target "&save_target.";
%let g_scnid = &save_g_scnid.;
%endTestcall();

%assertColumns(i_expected=work.expected_tst,  i_actual=work.tst,  i_desc=check on equality)
%endTestcase();

%endScenario();
/** \endcond */
