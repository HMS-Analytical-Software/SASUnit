/** 
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertLibrary.sas, has to fail!

   \version 1.1
   \author  Klaus Landwich
   \date    21.10.2008

*/

/*DE
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests für assertLibrary.sas, muss rot sein

   \version 1.1
   \author  Klaus Landwich
   \date    21.10.2008

*/
/** \cond */ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* Testfall 1 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=i_actual ist ein ungültiger Libref - muss rot sein!)
%endTestcall()

%assertLibrary (i_expected=WORK, i_actual=CTEMP, i_desc=muss rot sein!)

%assertLog (i_errors=0, i_warnings=0)

/* Testfall 2 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=i_expected ist ein ungültiger Libref - muss rot sein!)
%endTestcall()

%assertLibrary (i_expected=CTEMP, i_actual=WORK, i_desc=muss rot sein!)

%assertLog (i_errors=0, i_warnings=0);


/* Testfall 3 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Beide Librefs identisch - muss rot sein!)
%endTestcall()

%assertLibrary (i_expected=WORK, i_actual=WORK, i_desc=muss rot sein!)

%assertLog (i_errors=0, i_warnings=0)

/* Testfall 4 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Beide Pfade identisch - muss rot sein!)
%endTestcall();

libname a "%sysfunc (pathname (WORK))";
libname b "%sysfunc (pathname (WORK))";

%assertLibrary (i_expected=a, i_actual=b, i_desc=muss rot sein!)

%assertLog (i_errors=0, i_warnings=0);

/* Testfall 5 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Beide Libs gefüllt - muss rot sein!)
%endTestcall();

%_sasunit_mkdir (%sysfunc (pathname (WORK))\_refdata);
%_sasunit_mkdir (%sysfunc (pathname (WORK))\_tstdata);
libname _ref  "%sysfunc (pathname (WORK))\_refdata";
libname _tst "%sysfunc (pathname (WORK))\_tstdata";
data _ref.class1                              _tst.class1 
     _ref.class2(drop=height)                 _tst.class2 
     _ref.class3(where=(sex='F'))             _tst.class3 
     _ref.class4(where=(sex='F') drop=height) _tst.class4 
                                              _tst.class5;
   set sashelp.class;
run;

%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_desc=Strict/Strict NoID - muss rot sein! 
                )
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_desc=MoreTables/Strict NoID - muss rot sein!  
                )
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_CompareCheck=MoreColumns, 
                i_desc=MoreTables/MoreCols NoID - muss rot sein!  
                )
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_CompareCheck=MoreObs, 
                i_desc=MoreTables/MoreObs NoID - muss rot sein!  
                )
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_CompareCheck=MoreColsNObs, 
                i_desc=MoreTables/MoreColsNObs NoID - muss rot sein!  
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

/* Testfall 6 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Zwei identische Libs)
%endTestcall();

%_sasunit_mkdir (%sysfunc (pathname (WORK))\_refdata1);
%_sasunit_mkdir (%sysfunc (pathname (WORK))\_tstdata1);
libname _ref  "%sysfunc (pathname (WORK))\_refdata1";
libname _tst "%sysfunc (pathname (WORK))\_tstdata1";
data _ref.class1 _tst.class1 
     _ref.class2 _tst.class2 
     _ref.class3 _tst.class3 
     _ref.class4 _tst.class4;
   set sashelp.class;
run;


%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_id=name age,
                i_desc=identische Libs 
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* Testfall 7 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Test-Lib mit mehr Tabellen - sonst identisch!)
%endTestcall();

%_sasunit_mkdir (%sysfunc (pathname (WORK))\_refdata2);
%_sasunit_mkdir (%sysfunc (pathname (WORK))\_tstdata2);
libname _ref  "%sysfunc (pathname (WORK))\_refdata2";
libname _tst "%sysfunc (pathname (WORK))\_tstdata2";
data _ref.class1 _tst.class1 
     _ref.class2 _tst.class2 
     _ref.class3 _tst.class3 
     _ref.class4 _tst.class4 
                 _tst.class5;
   set sashelp.class;
run;


%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_id=name age,
                i_desc=MoreTables
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* Testfall 8 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Test-Lib mit mehr Obs!)
%endTestcall();

%_sasunit_mkdir (%sysfunc (pathname (WORK))\_refdata3);
%_sasunit_mkdir (%sysfunc (pathname (WORK))\_tstdata3);
libname _ref  "%sysfunc (pathname (WORK))\_refdata3";
libname _tst "%sysfunc (pathname (WORK))\_tstdata3";
data _ref.class1 (where=(sex='F')) _tst.class1 
     _ref.class2 _tst.class2 
     _ref.class3 (where=(sex='M')) _tst.class3 
     _ref.class4 _tst.class4;
   set sashelp.class;
run;


%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_CompareCheck=MoreObs, 
                i_id=name age,
                i_desc=MoreObs 
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* Testfall 9 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Test-Lib mit Cols!)
%endTestcall();

%_sasunit_mkdir (%sysfunc (pathname (WORK))\_refdata4);
%_sasunit_mkdir (%sysfunc (pathname (WORK))\_tstdata4);
libname _ref  "%sysfunc (pathname (WORK))\_refdata4";
libname _tst "%sysfunc (pathname (WORK))\_tstdata4";
data _ref.class1               _tst.class1 
     _ref.class2 (drop=height) _tst.class2 
     _ref.class3 (drop=weight) _tst.class3 
     _ref.class4               _tst.class4; 
   set sashelp.class;
run;


%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_CompareCheck=MoreColsNObs, 
                i_id=name age,
                i_desc=MoreCols
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* Testfall 10 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Test-Lib mit mehr Obs und mehr Cols!)
%endTestcall();

%_sasunit_mkdir (%sysfunc (pathname (WORK))\_refdata5);
%_sasunit_mkdir (%sysfunc (pathname (WORK))\_tstdata5);
libname _ref  "%sysfunc (pathname (WORK))\_refdata5";
libname _tst "%sysfunc (pathname (WORK))\_tstdata5";
data _ref.class1 (where=(sex='F'))             _tst.class1 
     _ref.class2 (drop=height)                 _tst.class2 
     _ref.class3 (where=(sex='M') drop=weight) _tst.class3 
     _ref.class4                               _tst.class4;
   set sashelp.class;
run;


%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_CompareCheck=MoreColsNObs, 
                i_id=name age,
                i_desc=MoreColsNObs 
)

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/** \endcond */ 
