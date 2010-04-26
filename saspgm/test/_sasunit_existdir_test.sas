/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test von _sasunit_existDir.sas

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
*/ /** \cond */ 

%let existing = %sysfunc(pathname(work));
%let existing2 = %sysfunc(pathname(work))/;
%let not_existing = y:\ljfds�\jdsa�\jdsa�l\urewqio;

%initTestcase(i_object=_sasunit_existdir.sas, i_desc=existierendes Verzeichnis)
%LET exists = %_sasunit_existdir(&existing);
%endTestcall;
%assertEquals(i_expected=1, i_actual=&exists, i_desc=Verzeichnis existiert)
%endTestcase;

%initTestcase(i_object=_sasunit_existdir.sas, i_desc=existierendes Verzeichnis mit abschlie�endem /)
%LET exists = %_sasunit_existdir(&existing2);
%endTestcall;
%assertEquals(i_expected=1, i_actual=&exists, i_desc=Verzeichnis existiert)
%endTestcase;

%initTestcase(i_object=_sasunit_existdir.sas, i_desc=existierendes Verzeichnis)
%LET exists = %_sasunit_existdir(&not_existing);
%endTestcall;
%assertEquals(i_expected=0, i_actual=&exists, i_desc=Verzeichnis existiert nicht)
%endTestcase;

/** \endcond */
