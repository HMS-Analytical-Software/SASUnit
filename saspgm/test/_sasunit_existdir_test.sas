/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_existDir.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

%let existing = %sysfunc(pathname(work));
%let existing2 = %sysfunc(pathname(work))/;
%let not_existing = y:\ljfdsö\jdsaö\jdsaöl\urewqio;

%initTestcase(i_object=_sasunit_existdir.sas, i_desc=existing folder)
%LET exists = %_sasunit_existdir(&existing);
%endTestcall;
%assertEquals(i_expected=1, i_actual=&exists, i_desc=folder exists)
%endTestcase;

%initTestcase(i_object=_sasunit_existdir.sas, i_desc=existing folder with terminating /)
%LET exists = %_sasunit_existdir(&existing2);
%endTestcall;
%assertEquals(i_expected=1, i_actual=&exists, i_desc=folder exists)
%endTestcase;

%initTestcase(i_object=_sasunit_existdir.sas, i_desc=not existing folder)
%LET exists = %_sasunit_existdir(&not_existing);
%endTestcall;
%assertEquals(i_expected=0, i_actual=&exists, i_desc=folder does not exists)
%endTestcase;

/** \endcond */
