/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertperformance.sas - has to fail!

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
%initTestcase(
    i_object=assertPerformance.sas
   ,i_desc=runtime less than 4 seconds
)

data _null_;
   call sleep (3,1);
run;
%endTestcall()

%assertPerformance (i_expected=4, i_desc=Runtime less than 4 seconds);

%assertLog (i_errors=0, i_warnings=0)

/* test case 2 ------------------------------------ */
%initTestcase(
    i_object=assertPerformance.sas
   ,i_desc=runtime equals expected value
)

data _null_;
   call sleep (4,1);
run;

%endTestcall()

proc sql noprint;
   select max(cas_id) INTO :_casid FROM target.cas WHERE cas_scnid=&g_scnid;
   select cas_end - cas_start INTO :_RunTime FROM target.cas WHERE cas_scnid = &g_scnid. AND cas_id = &_casid.;
quit;

%assertPerformance (i_expected=&_RunTime., i_desc=Runtime equals expected value);

%assertLog (i_errors=0, i_warnings=0);

/* test case 3 ------------------------------------ */
%initTestcase(
    i_object=assertPerformance.sas
   ,i_desc=runtime greater than 4 seconds - must be red!
);

data _null_;
   call sleep (5,1);
run;
%endTestcall()

%assertPerformance (i_expected=4, i_desc=Runtime equal 4 seconds);

%assertLog (i_errors=0, i_warnings=0)

/* test case 4 ------------------------------------ */
%initTestcase(
    i_object=assertPerformance.sas
   ,i_desc=runtime exceeds expected value by 1 billionth - must be red!
)

data _null_;
   call sleep (4,1);
run;

%endTestcall()

proc sql noprint;
   select max(cas_id) INTO :_casid FROM target.cas WHERE cas_scnid=&g_scnid;
   select cas_end - cas_start INTO :_RunTime FROM target.cas WHERE cas_scnid = &g_scnid. AND cas_id = &_casid.;
quit;

/* create artificial difference in expected and actual runtime */
%let _RunTime=%sysevalf(&_RunTime-0.00000000000001);

%assertPerformance (i_expected=&_RunTime., i_desc=Runtime exceeds expected value by 1 billionth - must be red!);

%assertLog (i_errors=0, i_warnings=0);

/** \endcond */
