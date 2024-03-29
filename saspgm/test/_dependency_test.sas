/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of _dependency.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
*/ /** \cond */

%MACRO _createTestFiles;
   /* Create data */
   DATA listcalling_test;
      KEEP caller called;
      
      *deep tree to check recursive calls;
      DO i=1 TO 20;
         caller = CATT("macro_",i);
         called = CATT("macro_", i+1);
         OUTPUT;
      END;
      
      *self referrential call;
      caller = "macro_A"; called = "macro_B"; OUTPUT;
      caller = "macro_b"; called = "macro_a"; OUTPUT;
   RUN;

   DATA dir_test;
      name = "macro_A"; OUTPUT;
      name = "macro_1"; OUTPUT;
   RUN;
   
   DATA siblings;
      caller = "parent"; called = "sibling_1"; OUTPUT;
      caller = "parent"; called = "sibling_2"; OUTPUT;
      caller = "parent"; called = "sibling_3"; OUTPUT;
      caller = "parent"; called = "sibling_4"; OUTPUT;
      caller = "parent"; called = "sibling_5"; OUTPUT;
   RUN;
   
   DATA siblings_dir;
      name = "parent";    OUTPUT;
      name = "sibling_1"; OUTPUT;
      name = "sibling_2"; OUTPUT;
      name = "sibling_3"; OUTPUT;
      name = "sibling_4"; OUTPUT;
      name = "sibling_5"; OUTPUT;
   RUN;
   
   /* Create folders */
   %_mkdir(%SYSFUNC(PATHNAME(work))/tempDoc);
   %_mkdir(%SYSFUNC(PATHNAME(work))/tempDoc/crossreference);
   
 /* Create expected json files for assert columns */
   DATA macro_1_called_exp;
      length line $100;
      array macro_1_called[2] $100 _temporary_ ('{ "name": "macro_1"' '}');
      drop i;
      DO i=1 TO dim(macro_1_called);
         line = macro_1_called[i];
         OUTPUT;
      END;
   RUN;

   DATA macro_1_caller_exp;
      length line $100;
      array macro_1_caller[82] $100 _temporary_ (
         '{ "name": "macro_1" ' ', "children": [' '{ "name": "macro_2" ' ', "children": [' '{ "name": "macro_3" ' ', "children": ['
         '{ "name": "macro_4" ' ', "children": [' '{ "name": "macro_5" ' ', "children": [' '{ "name": "macro_6" ' ', "children": ['
         '{ "name": "macro_7" ' ', "children": [' '{ "name": "macro_8" ' ', "children": [' '{ "name": "macro_9" ' ', "children": ['
         '{ "name": "macro_10"' ', "children": [' '{ "name": "macro_11"' ', "children": [' '{ "name": "macro_12"' ', "children": ['
         '{ "name": "macro_13"' ', "children": [' '{ "name": "macro_14"' ', "children": [' '{ "name": "macro_15"'
         ', "children": [' '{ "name": "macro_16"' ', "children": [' '{ "name": "macro_17"' ', "children": ['
         '{ "name": "macro_18"' ', "children": [' '{ "name": "macro_19"' ', "children": [' '{ "name": "macro_20"'
         ', "children": [' '{ "name": "macro_21"' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}'
         ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}'
      );
      drop i;
      DO i=1 TO dim(macro_1_caller);
         line = macro_1_caller[i];
         OUTPUT;
      END;
   RUN;

   DATA macro_A_called_exp;
      length line $100;
      array macro_A_called[10] $100 _temporary_ (
         '{ "name": "macro_A"'
         ', "children": ['
         '{ "name": "macro_b"'
         ', "children": ['
         '{ "name": "macro_A"'
         '}' ']' '}' ']' '}'
      );
      drop i;
      DO i=1 TO dim(macro_A_called);
         line = macro_A_called[i];
         OUTPUT;
      END;
   RUN;

   DATA macro_A_caller_exp;
      length line $100;
      array macro_A_caller[10] $100 _temporary_ (
         '{ "name": "macro_A"'
         ', "children": ['
         '{ "name": "macro_B"'
         ', "children": ['
         '{ "name": "macro_a"'
         '}' ']' '}' ']' '}'
      );
      drop i;
      DO i=1 TO dim(macro_A_caller);
         line = macro_A_caller[i];
         OUTPUT;
      END;
   RUN;
   
   DATA parent_caller_exp;
      length line $100;
      array parent_caller[14] $100 _temporary_ (
         '{ "name": "parent"'
         ', "children": ['
         '{ "name": "sibling_1"'
         '},'
         '{ "name": "sibling_2"'
         '},'
         '{ "name": "sibling_3"'
         '},'
         '{ "name": "sibling_4"'
         '},'
         '{ "name": "sibling_5"'
         '}' ']' '}'
      );
      drop i;
      DO i=1 TO dim(parent_caller);
         line = parent_caller[i];
         OUTPUT;
      END;
   RUN;
   
   DATA parent_called_exp;
      length line $100;
      array parent_called[2] $100 _temporary_ (
         '{ "name": "parent"'
         '}'
      );
      drop i;
      DO i=1 TO dim(parent_called);
         line = parent_called[i];
         OUTPUT;
      END;
   RUN;
   
%MEND _createTestFiles;

%initScenario (i_desc=Test of _dependency.sas)

/* create test files */
%_createTestFiles;

%let g_reportFolderSave = &g_reportFolder.;

/* test case 1 ------------------------------------ */
%initTestcase(i_object=_dependency.sas, i_desc=Test if JSON files have been created);
%let g_reportFolder=%SYSFUNC(PATHNAME(work));
%_switch();
   %_dependency(i_dependencies=listcalling_test, i_macroList=dir_test);
%_switch();
%let g_reportFolder=&g_reportFolderSave.;
%endTestcall();
   %markTest();
      /* Files and folder test */
      %assertEquals(i_actual=%SYSFUNC(FILEEXIST(%SYSFUNC(PATHNAME(work))/tempDoc/crossreference/macro_A_called.json)) ,i_expected=1, i_desc=Json File macro_A_called.json created successfully );
      %assertEquals(i_actual=%SYSFUNC(FILEEXIST(%SYSFUNC(PATHNAME(work))/tempDoc/crossreference/macro_A_caller.json)) ,i_expected=1, i_desc=Json File macro_A_caller.json created successfully );
      %assertEquals(i_actual=%SYSFUNC(FILEEXIST(%SYSFUNC(PATHNAME(work))/tempDoc/crossreference/macro_1_called.json)) ,i_expected=1, i_desc=Json File macro_1_called.json created successfully );
      %assertEquals(i_actual=%SYSFUNC(FILEEXIST(%SYSFUNC(PATHNAME(work))/tempDoc/crossreference/macro_1_caller.json)) ,i_expected=1, i_desc=Json File macro_1_caller.json created successfully );
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 2 ------------------------------------ */
filename in "%sysfunc(pathname(work))/tempDoc/crossreference/macro_A_called.json";
DATA macro_A_called;
   length line $100;
   infile in;
   input;
   line = _infile_;
RUN;

filename in "%sysfunc(pathname(work))/tempDoc/crossreference/macro_A_caller.json";
DATA macro_A_caller;
   length line $100;
   infile in;
   input;
   line = _infile_;
run;

filename in "%sysfunc(pathname(work))/tempDoc/crossreference/macro_1_called.json";
DATA macro_1_called;
   length line $100;
   infile in;
   input;
   line = _infile_;
RUN;

filename in "%sysfunc(pathname(work))/tempDoc/crossreference/macro_1_caller.json";
DATA macro_1_caller;
   length line $100;
   infile in;
   input;
   line = _infile_;
RUN;

filename in;

%initTestcase(i_object=_dependency.sas, i_desc=Test correct representation of parent-child relationship);
%endTestcall();
   %markTest();
      /* Test correct representation of sibling relationships */
      %assertColumns(i_actual=macro_A_caller, i_expected=macro_A_caller_exp, i_desc=Assert Columns for macro_A caller);
      %assertColumns(i_actual=macro_A_called, i_expected=macro_A_called_exp, i_desc=Assert Columns for macro_A called);
      %assertColumns(i_actual=macro_1_caller, i_expected=macro_1_caller_exp, i_desc=Assert Columns for macro_1 caller);
      %assertColumns(i_actual=macro_1_called, i_expected=macro_1_called_exp, i_desc=Assert Columns for macro_1 called);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 3 ------------------------------------ */
%initTestcase(i_object=_dependency.sas, i_desc=Test correct representation of sibling relationships);
%let g_reportFolder=%SYSFUNC(PATHNAME(work));
%_switch();
   %_dependency(i_dependencies=siblings, i_macroList=siblings_dir);
%_switch();
%let g_reportFolder=&g_reportFolderSave.;

filename in "%sysfunc(pathname(work))/tempDoc/crossreference/parent_caller.json";
DATA parent_caller;
   length line $100;
   infile in;
   input;
   line = _infile_;
RUN;

filename in "%sysfunc(pathname(work))/tempDoc/crossreference/parent_called.json";
DATA parent_called;
   length line $100;
   infile in;
   input;
   line = _infile_;
RUN;

filename in;

%endTestcall();
   %markTest();
      /* Test correct representation of sibling relationships*/
      %assertColumns(i_actual=parent_caller, i_expected=parent_caller_exp, i_desc=Assert Columns for parent_caller);
      %assertColumns(i_actual=parent_called, i_expected=parent_called_exp, i_desc=Assert Columns for parent_called);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

%endScenario();
/** endcond **/
