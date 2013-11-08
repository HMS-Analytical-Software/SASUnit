/** 
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of _assertLibrary.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*//** \cond */  

%let scnid = %substr(00&g_scnid,%length(&g_scnid));
%global sal_rc;

/* test case 1 ------------------------------------*/
%initTestcase(i_object=_assertLibrary.sas, i_desc=diverse differences)
%endTestcall();

%_mkdir (%sysfunc (pathname (WORK))/_refdata);
%_mkdir (%sysfunc (pathname (WORK))/_tstdata);
libname _ref  "%sysfunc (pathname (WORK))/_refdata";
libname _tst "%sysfunc (pathname (WORK))/_tstdata";
data _ref.class1                              _tst.class1 
     _ref.class2(drop=height)                 _tst.class2 
     _ref.class3(where=(sex='F'))             _tst.class3 
     _ref.class4(where=(sex='F') drop=height) _tst.class4 
                                              _tst.class5;
   set sashelp.class;
run;

%let sal_rc=-1;
%_assertLibrary (i_expected=_ref
                ,i_actual=_tst
                ,o_result=sal_rc
                );
%assertEquals   (i_expected=2, i_actual=&sal_rc., i_desc=Must be identical);
%markTest()
%_xcmd(&g_removedir "&g_target./tst/_&scnid._&casid._&tstid._assertlibrary");

%let sal_rc=-1;
%_assertLibrary (i_expected=_ref
                ,i_actual=_tst
                ,i_LibraryCheck=%upcase(MoreTables)
                ,o_result=sal_rc
                );
%assertEquals   (i_expected=2, i_actual=&sal_rc., i_desc=Must be identical);
%markTest()
%_xcmd(&g_removedir "&g_target./tst/_&scnid._&casid._&tstid._assertlibrary");

%let sal_rc=-1;
%_assertLibrary (i_expected=_ref
                ,i_actual=_tst
                ,i_LibraryCheck=%upcase(MoreTables)
                ,i_CompareCheck=%upcase(MoreColumns)
                ,o_result=sal_rc
                );
%assertEquals   (i_expected=2, i_actual=&sal_rc., i_desc=Must be identical);
%markTest()
%_xcmd(&g_removedir "&g_target./tst/_&scnid._&casid._&tstid._assertlibrary");

%let sal_rc=-1;
%_assertLibrary (i_expected=_ref
                ,i_actual=_tst
                ,i_LibraryCheck=%upcase(MoreTables)
                ,i_CompareCheck=%upcase(MoreObs)
                ,o_result=sal_rc
                );
%assertEquals   (i_expected=2, i_actual=&sal_rc., i_desc=Must be identical);
%markTest()
%_xcmd(&g_removedir "&g_target./tst/_&scnid._&casid._&tstid._assertlibrary");

%let sal_rc=-1;
%_assertLibrary (i_expected=_ref
                ,i_actual=_tst
                ,i_LibraryCheck=%upcase(MoreTables)
                ,i_CompareCheck=%upcase(MoreColsNObs)
                ,o_result=sal_rc
                );
%assertEquals   (i_expected=2, i_actual=&sal_rc., i_desc=Must be identical);
%markTest()
%_xcmd(&g_removedir "&g_target./tst/_&scnid._&casid._&tstid._assertlibrary");

%let sal_rc=-1;
%_assertLibrary (i_expected=_ref
                ,i_actual=_tst
                ,i_LibraryCheck=%upcase(MoreTables)
                ,i_CompareCheck=%upcase(MoreColsNObs)
                ,i_id=name age
                ,o_result=sal_rc
                );
%assertEquals   (i_expected=0, i_actual=&sal_rc., i_desc=Must be identical);
%markTest()
%_xcmd(&g_removedir "&g_target./tst/_&scnid._&casid._&tstid._assertlibrary");

%let sal_rc=-1;
%_assertLibrary (i_expected=_ref
                ,i_actual=_tst
                ,i_LibraryCheck=%upcase(MoreTables)
                ,i_id=name age
                ,i_ExcludeList=class2 class3 class4 
                ,o_result=sal_rc
                );
%assertEquals   (i_expected=0, i_actual=&sal_rc., i_desc=Must be identical);
%markTest()
%_xcmd(&g_removedir "&g_target./tst/_&scnid._&casid._&tstid._assertlibrary");

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/** \endcond */ 
