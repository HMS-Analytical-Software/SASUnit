/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test von _sasunit_nobs.sas

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
*/ /** \cond */ 
      
data test1;
   do i=1 to 100;
      output;
   end;
run;

%initTestcase(i_object=_sasunit_nobs.sas, i_desc=Standardfall mit 100 Obs)
%LET g_nobs = %_sasunit_nobs(test1);
%assertEquals(i_expected=100, i_actual=&g_nobs, i_desc=Anzahl Obs muss 100 sein)
%assertLog()
%endTestcase()

data test2;
   stop;
run;

%initTestcase(i_object=_sasunit_nobs.sas, i_desc=Datei mit 0 Obs)
%LET g_nobs = %_sasunit_nobs(test2);
%assertEquals(i_expected=0, i_actual=&g_nobs, i_desc=Anzahl Obs muss 0 sein)
%assertLog()

%initTestcase(i_object=_sasunit_nobs.sas, i_desc=Nicht vorhandene Datei)
%LET g_nobs = %_sasunit_nobs(test3);
%assertEquals(i_expected=0, i_actual=&g_nobs, i_desc=Anzahl Obs muss 0 sein)
%assertLog()
%endTestcase;
/** \endcond */
