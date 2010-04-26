/** 
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertLibrary.sas, has to fail!

   \version 1.0
   \author  Klaus Landwich
   \date    10.08.2007

*/

/*DE
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests für assertLibrary.sas, muss rot sein

   \version 1.0
   \author  Klaus Landwich
   \date    10.08.2007

*/
/** \cond */ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* Testfall 1 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=i_actual ist ein ungültiger Libref - muss rot sein!)
%endTestcall()

%assertLibrary (i_expected=WORK, i_actual=CTEMP, i_desc=muss rot sein!)

%assertLog (i_errors=0, i_warnings=0)
/*
%assertLogMsg (i_logmsg   = &g_ERROR.: Libref i_actual () ist ungültig!);
*/

/* Testfall 2 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=i_expected ist ein ungültiger Libref - muss rot sein!)
%endTestcall()


%assertLibrary (i_expected=CTEMP, i_actual=WORK, i_desc=muss rot sein!)

%assertLog (i_errors=0, i_warnings=0);
/*
%assertLogMsg (i_logmsg   = &g_ERROR.: Libref i_expected () ist ungültig!);
*/


/* Testfall 3 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Beide Librefs identisch - muss rot sein!)
%endTestcall()

%assertLibrary (i_expected=WORK, i_actual=WORK, i_desc=muss rot sein!)

%assertLog (i_errors=0, i_warnings=0)
/*
%assertLogMsg (i_logmsg   = &g_ERROR.: Libref i_actual () ist ungültig!);
*/

/* Testfall 4 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Beide Pfade identisch - muss rot sein!)
%endTestcall();

libname a "%sysfunc (pathname (WORK))";
libname b "%sysfunc (pathname (WORK))";

%assertLibrary (i_expected=a, i_actual=b, i_desc=muss rot sein!)

%assertLog (i_errors=0, i_warnings=0);
/*
%*assertLogMsg (i_logmsg   = &g_ERROR.: Libref i_actual () ist ungültig!);
*/

/* Testfall 4 ------------------------------------*/
%initTestcase(i_object=assertLibrary.sas, i_desc=Beide Libs gefüllt - muss rot sein!)
%endTestcall();

%_sasunit_mkdir (%sysfunc (pathname (WORK))\_refdata);
%_sasunit_mkdir (%sysfunc (pathname (WORK))\_tstdata);
libname _ref  "%sysfunc (pathname (WORK))\_refdata";
libname _tst "%sysfunc (pathname (WORK))\_tstdata";
data _ref.class1 _tst.class1 
     _ref.class2 _tst.class2(drop=height)  
     _ref.class3 _tst.class3(where=(sex='F')) 
     _ref.class4 _tst.class4(where=(sex='F') drop=height) 
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
                i_desc=MoreTables/MoreColsNObs NoID 
)
%assertLibrary (i_expected=_ref, 
                i_actual=_tst, 
                i_LibraryCheck=MoreTables, 
                i_id=name age,
                i_desc=MoreTables ExcludeList,
                i_ExcludeList=class2 class3 class4 
)

%assertLog (i_errors=0, i_warnings=0)
/*
%*assertLogMsg (i_logmsg   = &g_ERROR.: Libref i_actual () ist ungültig!);
*/

%endTestcase()

/** \endcond */ 
