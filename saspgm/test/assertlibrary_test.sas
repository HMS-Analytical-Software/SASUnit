/** 
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertlibrary.sas - has to fail! 4 errors concerning libref statements and 2 error with invalid values of parameters

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

/* test case 1 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=i_actual is an invalid libref - must be red!)
%endTestcall()

%assertLibrary (i_expected=WORK, i_actual=CTEMP, i_desc=must be red!)

%assertLog (i_errors=0, i_warnings=0)

/* test case 2 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=i_expected is an invalid libref - must be red!)
%endTestcall()

%assertLibrary (i_expected=CTEMP, i_actual=WORK, i_desc=must be red!)

%assertLog (i_errors=0, i_warnings=0);


/* test case 3 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=identical librefs - must be red!)
%endTestcall()

%assertLibrary (i_expected=WORK, i_actual=WORK, i_desc=must be red!)

%assertLog (i_errors=0, i_warnings=0)

/* test case 4 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=identical paths - must be red!)
%endTestcall();

libname a "%sysfunc (pathname (WORK))";
libname b "%sysfunc (pathname (WORK))";

%assertLibrary (i_expected=a, i_actual=b, i_desc=must be red!)

%assertLog (i_errors=0, i_warnings=0);

/* test case 5 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=diverse differences - must be red!)
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

%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_desc=Strict/Strict NoID - must be red! 
                )
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_desc=MoreTables/Strict NoID - must be red!  
                )
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_CompareCheck=MoreColumns, 
                i_desc=MoreTables/MoreCols NoID - must be red!  
                )
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_CompareCheck=MoreObs, 
                i_desc=MoreTables/MoreObs NoID - must be red!  
                )
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_CompareCheck=MoreColsNObs, 
                i_desc=MoreTables/MoreColsNObs NoID - must be red!  
                )
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_CompareCheck=MoreColsNObs, 
                i_id=name age,
                i_desc=MoreTables/MoreColsNObs 
)
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_id=name age,
                i_desc=MoreTables ExcludeList,
                i_ExcludeList=class2 class3 class4 
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* test case 6 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=libraries with identical contents)
%endTestcall();

%_mkdir (%sysfunc (pathname (WORK))/_refdata1);
%_mkdir (%sysfunc (pathname (WORK))/_tstdata1);
libname _ref  "%sysfunc (pathname (WORK))/_refdata1";
libname _tst "%sysfunc (pathname (WORK))/_tstdata1";
data _ref.class1 _tst.class1 
     _ref.class2 _tst.class2 
     _ref.class3 _tst.class3 
     _ref.class4 _tst.class4;
   set sashelp.class;
run;


%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_id=name age,
                i_desc=identical contents
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* test case 7 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=more tables in one library - otherwise identical!)
%endTestcall();

%_mkdir (%sysfunc (pathname (WORK))/_refdata2);
%_mkdir (%sysfunc (pathname (WORK))/_tstdata2);
libname _ref  "%sysfunc (pathname (WORK))/_refdata2";
libname _tst "%sysfunc (pathname (WORK))/_tstdata2";
data _ref.class1 _tst.class1 
     _ref.class2 _tst.class2 
     _ref.class3 _tst.class3 
     _ref.class4 _tst.class4 
                 _tst.class5;
   set sashelp.class;
run;


%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_libraryCheck=MoreTables, 
                i_id=name age,
                i_desc=MoreTables
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* test case 8 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=test library has more observations!)
%endTestcall();

%_mkdir (%sysfunc (pathname (WORK))/_refdata3);
%_mkdir (%sysfunc (pathname (WORK))/_tstdata3);
libname _ref  "%sysfunc (pathname (WORK))/_refdata3";
libname _tst "%sysfunc (pathname (WORK))/_tstdata3";
data _ref.class1 (where=(sex='F')) _tst.class1 
     _ref.class2 _tst.class2 
     _ref.class3 (where=(sex='M')) _tst.class3 
     _ref.class4 _tst.class4;
   set sashelp.class;
run;


%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_compareCheck=MoreObs, 
                i_id=name age,
                i_desc=MoreObs 
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* test case 9 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=test library has more columns!)
%endTestcall();

%_mkdir (%sysfunc (pathname (WORK))/_refdata4);
%_mkdir (%sysfunc (pathname (WORK))/_tstdata4);
libname _ref  "%sysfunc (pathname (WORK))/_refdata4";
libname _tst "%sysfunc (pathname (WORK))/_tstdata4";
data _ref.class1               _tst.class1 
     _ref.class2 (drop=height) _tst.class2 
     _ref.class3 (drop=weight) _tst.class3 
     _ref.class4               _tst.class4; 
   set sashelp.class;
run;


%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_compareCheck=MoreColsNObs, 
                i_id=name age,
                i_desc=MoreCols
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* test case 10 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=test library has more observations and more columns!)
%endTestcall();

%_mkdir (%sysfunc (pathname (WORK))/_refdata5);
%_mkdir (%sysfunc (pathname (WORK))/_tstdata5);
libname _ref  "%sysfunc (pathname (WORK))/_refdata5";
libname _tst "%sysfunc (pathname (WORK))/_tstdata5";
data _ref.class1 (where=(sex='F'))             _tst.class1 
     _ref.class2 (drop=height)                 _tst.class2 
     _ref.class3 (where=(sex='M') drop=weight) _tst.class3 
     _ref.class4                               _tst.class4;
   set sashelp.class;
run;


%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_libraryCheck=MoreTables, 
                i_compareCheck=MoreColsNObs, 
                i_id=name age,
                i_desc=MoreColsNObs 
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* test case 11 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=test with invalid value of i_libraryCheck - must be red!)
%endTestcall()

%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_libraryCheck=NoMoreTables, 
                i_desc=must be red 
)

%assertLog (i_errors=0, i_warnings=0)

/* test case 12 ------------------------------------*/
%initTestcase(i_object=assertlibrary.sas, i_desc=test with invalid value of i_compareCheck - must be red!)
%endTestcall()

%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_compareCheck=NoMoreColsNObs, 
                i_desc=must be red 
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()
/** \endcond */ 
