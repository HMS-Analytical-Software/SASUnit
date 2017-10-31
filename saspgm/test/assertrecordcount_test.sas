/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertRecordCount.sas - has to fail! 3 errors (1 non-existing variable, 2 errors invalid where-syntax)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%initScenario(i_desc =%str(Test of assertRecordCount.sas - has to fail! 3 errors %(1 non-existing variable, 2 errors invalid where-syntax%)));

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */

%initTestcase(
             i_object=assertRecordCount.sas
            ,i_desc=Tests with invalid parameters
   )
%endTestcall()

%assertRecordCount(i_libref=work, i_memname=class, i_operator=EQ, i_recordsExp=19, i_desc=test with invalid member name);
   %markTest()
      %assertDBValue(tst,exp,EQ 19)
      %assertDBValue(tst,act,-1)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertRecordCount(i_libref=dummy, i_memname=class, i_operator=EQ, i_recordsExp=4, i_where=%str(age = 14), i_desc=test with invalid library );
   %markTest()
      %assertDBValue(tst,exp,EQ 4)
      %assertDBValue(tst,act,-1)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertRecordCount(i_libref=sashelp, i_memname=class, i_operator=EQ, i_recordsExp=hugo, i_where=%str(age = 14), i_desc=test with invalid i_recordsExp);
   %markTest()
      %assertDBValue(tst,exp,EQ hugo)
      %assertDBValue(tst,act,-3)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertRecordCount(i_libref=sashelp, i_memname=class, i_operator=LT, i_recordsExp=-4, i_where=%str(age = 14), i_desc=test with invalid i_recordsExp);
   %markTest()
      %assertDBValue(tst,exp,LT -4)
      %assertDBValue(tst,act,-4)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertRecordCount(i_libref=sashelp, i_memname=class, i_operator=dummy, i_recordsExp=6, i_where=%str(age = 14), i_desc=test with invalid operator);
   %markTest()
      %assertDBValue(tst,exp,DUMMY 6)
      %assertDBValue(tst,act,-5)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertLog (i_errors=0, i_warnings=0)
%endTestcase();

/* test case 2 ------------------------------------ */
%initTestcase(
             i_object=assertRecordCount.sas
            ,i_desc=Tests with invalid where clause 
   )

%endTestcall()
%assertRecordCount(i_libref=sashelp, i_memname=class, i_operator=EQ, i_recordsExp=19, i_where= hugo, i_desc=Invalid where clause);
   %markTest()
      %assertDBValue(tst,exp,EQ 19)
      %assertDBValue(tst,act,-2)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertRecordCount(i_libref=sashelp, i_memname=class, i_operator=<=, i_recordsExp=21, i_where=%str(age = 14  weight < 100), i_desc=Invalid where clause: missing AND);
   %markTest()
      %assertDBValue(tst,exp,<= 21)
      %assertDBValue(tst,act,-2)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertLog (i_errors=0, i_warnings=0)
%endTestcase();
/* test case 3 ------------------------------------ */
%initTestcase(
             i_object=assertRecordCount.sas
            ,i_desc=Successful test with different parameters
   )

%endTestcall()

%assertRecordCount(i_libref=sashelp, i_memname=class,                         i_recordsExp=19,                          i_desc=test with default operator EQ and no where-clause);
%assertRecordCount(i_libref=sashelp, i_memname=class,    i_operator=%str(=),  i_recordsExp=4,   i_where=%str(age = 14), i_desc=Test with operator %str(=));
%assertRecordCount(i_libref=sashelp, i_memname=class,    i_operator=LT,       i_recordsExp=6,   i_where=%str(age = 14), i_desc=test with operator LT);
%assertRecordCount(i_libref=sashelp, i_memname=class,    i_operator=~=,       i_recordsExp=6,   i_where=%str(age = 14), i_desc=test with operator ~=);
%assertRecordCount(i_libref=sashelp, i_memname=class,    i_operator=NE,       i_recordsExp=6,   i_where=%str(age = 14), i_desc=test with operator NE);
%assertRecordCount(i_libref=sashelp, i_memname=class,    i_operator=<=,       i_recordsExp=2,  i_where=%str(age = 14 and weight < 100), i_desc=complex where condition);
%assertLog (i_errors=0, i_warnings=0)
%endTestcase();

%endScenario();
/** \endcond */
