/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _existVar.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _existVar.sas);

%initTestcase(i_object=_existVar.sas, i_desc=Test for numeric variable age)
%let rc=%_existVar (sashelp.class
                   ,age
                   ,N
                   ); 
%endTestcall;

%assertEquals(i_expected=1,  i_actual=&rc.,  i_desc=Numeric variable age exists)
%endTestcase;

%initTestcase(i_object=_existVar.sas, i_desc=Test for character variable age)
%let rc=%_existVar (sashelp.class
                   ,age
                   ,C
                   ); 
%endTestcall;

%assertEquals(i_expected=0,  i_actual=&rc.,  i_desc=Character variable age does not exist)
%endTestcase;

%initTestcase(i_object=_existVar.sas, i_desc=Test for variable name)
%let rc=%_existVar (sashelp.class
                   ,name
                   ); 
%endTestcall;

%assertEquals(i_expected=1,  i_actual=&rc.,  i_desc=Variable name does not exist)
%endTestcase;

%endScenario();
/** \endcond */