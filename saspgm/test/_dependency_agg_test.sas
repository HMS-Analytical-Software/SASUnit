/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of _dependency_agg.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */

%MACRO _createtestfiles;  
 
   /* Create folders */
   %_mkdir(%SYSFUNC(PATHNAME(work))/tst);
   %_mkdir(%SYSFUNC(PATHNAME(work))/tst/jsonFolder);
   %_mkdir(%SYSFUNC(PATHNAME(work))/result);
   
 /* Create json files to aggregate with macro under test */
   FILENAME jsonfile "%SYSFUNC(PATHNAME(work))/tst/jsonFolder/file1_caller.json";
 
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
      file jsonfile;
      DO i=1 TO dim(macro_1_caller);
         line = macro_1_caller[i];
         put line;
      END;
   RUN;

   FILENAME jsonfile "%SYSFUNC(PATHNAME(work))/tst/jsonFolder/file1_called.json";
   DATA _NULL_;
      length line $100;
      array macro_A_called[10] $100 _temporary_ (
         '{ "name": "macro_A"'
         ', "children": ['
         '{ "name": "macro_B"'
         ', "children": ['
         '{ "name": "macro_A"'
         '}' ']' '}' ']' '}'
      );
      drop i;
      file jsonfile;
      DO i=1 TO dim(macro_A_called);
         line = macro_A_called[i];
         put line;
      END;
   RUN;

   FILENAME jsonfile "%SYSFUNC(PATHNAME(work))/tst/jsonFolder/file2_caller.json";
   DATA _NULL_;
      length line $100;
      array macro_A_caller[10] $100 _temporary_ (
         '{ "name": "macro_A"'
         ', "children": ['
         '{ "name": "macro_B"'
         ', "children": ['
         '{ "name": "macro_A"'
         '}' ']' '}' ']' '}'
      );
      drop i;
      file jsonfile;
      DO i=1 TO dim(macro_A_caller);
         line = macro_A_caller[i];
         put line;
      END;
   RUN;
   
   FILENAME jsonfile "%SYSFUNC(PATHNAME(work))/tst/jsonFolder/file2_called.json";
   DATA _NULL_;
      length line $100;
      array macro_A_caller[10] $100 _temporary_ (
         '{ "name": "macro_A"'
         ', "children": ['
         '{ "name": "macro_B"'
         ', "children": ['
         '{ "name": "macro_A"'
         '}' ']' '}' ']' '}'
      );
      drop i;
      file jsonfile;
      DO i=1 TO dim(macro_A_caller);
         line = macro_A_caller[i];
         put line;
      END;
   RUN;
   
    DATA jsFile_expected;
      length line $1000;
      array jsFile_expected[123] $1000 _temporary_ (
         'var allGraphs = [' '{ "id"     :  "file1"' ',   "called" :' '{ "name": "macro_A"' ', "children": ['
         '{ "name": "macro_B"' ', "children": [' '{ "name": "macro_A"' '}' ']' '}' ']' '}' ', "caller" :'
         '{ "name": "macro_1"' ', "children": [' '{ "name": "macro_2"' ', "children": [' '{ "name": "macro_3"' ', "children": ['
         '{ "name": "macro_4"' ', "children": [' '{ "name": "macro_5"' ', "children": [' '{ "name": "macro_6"' ', "children": ['
         '{ "name": "macro_7"' ', "children": [' '{ "name": "macro_8"' ', "children": [' '{ "name": "macro_9"' ', "children": ['
         '{ "name": "macro_10"' ', "children": [' '{ "name": "macro_11"' ', "children": [' '{ "name": "macro_12"' ', "children": ['
         '{ "name": "macro_13"' ', "children": [' '{ "name": "macro_14"' ', "children": [' '{ "name": "macro_15"' ', "children": ['
         '{ "name": "macro_16"' ', "children": [' '{ "name": "macro_17"' ', "children": [' '{ "name": "macro_18"' ', "children": ['
         '{ "name": "macro_19"' ', "children": [' '{ "name": "macro_20"' ', "children": [' '{ "name": "macro_21"'
         '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}' ']' '}'
         '} // file1' ',' '{ "id"     :  "file2"' ',   "called" :' '{ "name": "macro_A"' ', "children": [' '{ "name": "macro_B"'
         ', "children": [' '{ "name": "macro_A"' '}' ']' '}' ']' '}' ', "caller" :' '{ "name": "macro_A"' ', "children": ['
         '{ "name": "macro_B"' ', "children": [' '{ "name": "macro_A"' '}' ']' '}' ']' '}' '} // file2' '];'
      );
      drop i;
      DO i=1 TO dim(jsFile_expected);
         line = jsFile_expected[i];
         put line;
         output;
      END;
   RUN;  
   FILENAME jsonfile;   
%MEND _createtestfiles;

%initScenario (i_desc=Test of _dependency_agg.sas)

/* create test files */
%_createtestfiles;

/* test case 1 ------------------------------------ */
%initTestcase(i_object=_dependency_agg.sas, i_desc=Test if JSON and JavaScript files have been created and json object is well formed);
%_switch();
   %_dependency_agg(i_path = %SYSFUNC(PATHNAME(work))/tst/jsonFolder
                   ,o_file = %SYSFUNC(PATHNAME(work))/result/data.refs.js);
%_switch();
%endTestcall();
   %markTest();
      /* Files and folder test */
      %assertEquals(i_actual=%SYSFUNC(FILEEXIST(%SYSFUNC(PATHNAME(work))/tst/jsonFolder/file1_caller.json)) ,i_expected=1, i_desc=Json file file1_caller.json created successfully );
      %assertEquals(i_actual=%SYSFUNC(FILEEXIST(%SYSFUNC(PATHNAME(work))/tst/jsonFolder/file1_called.json)) ,i_expected=1, i_desc=Json file file1_called.json created successfully );
      %assertEquals(i_actual=%SYSFUNC(FILEEXIST(%SYSFUNC(PATHNAME(work))/tst/jsonFolder/file2_caller.json)) ,i_expected=1, i_desc=Json file file2_caller.json created successfully );
      %assertEquals(i_actual=%SYSFUNC(FILEEXIST(%SYSFUNC(PATHNAME(work))/tst/jsonFolder/file2_called.json)) ,i_expected=1, i_desc=Json file file2_called.json created successfully );
      %assertEquals(i_actual=%SYSFUNC(FILEEXIST(%SYSFUNC(PATHNAME(work))/result/data.refs.js))   ,i_expected=1, i_desc=JavaScript file data.refs.js created successfully );
      
      FILENAME actual "%SYSFUNC(PATHNAME(work))/result/data.refs.js";
      DATA jsFile_actual;
         length line $1000;
         infile actual;
         input;
         line = _infile_;
      RUN;
      FILENAME actual;
      
      %assertColumns(i_actual=jsFile_actual, i_expected=jsFile_expected, i_desc=Assert expected and actual file are identical);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

%endScenario();
/** endcond **/