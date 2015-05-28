/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertText.sas 

   \version    \$Revision: 190 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-05-29 18:04:27 +0200 (Mi, 29 Mai 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/asserttableexists_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%MACRO _createtestfiles;
   DATA _NULL_;
      FILE "&g_work./text1.txt";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt";
      PUT "ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo";
      PUT "dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut";
      PUT "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores";
      PUT "et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
   RUN;
   
   DATA _NULL_;
      FILE "&g_work./text1_copy.txt";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt";
      PUT "ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo";
      PUT "dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut";
      PUT "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores";
      PUT "et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
   RUN;
   
   DATA _NULL_;
      FILE "&g_work./text2.txt";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt";
      PUT "ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo";
      PUT "dolores blub ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut";
      PUT "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores";
      PUT "et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
   RUN;
   
   DATA _NULL_;
      FILE "&g_work./text3.txt";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt";
      PUT "ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo";
      PUT "Dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut";
      PUT "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores";
      PUT "et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
   RUN;

   DATA _NULL_;
      FILE "&g_work./text1_blanks.txt";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt";
      PUT "ut labore et dolore  magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo";
      PUT "dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
      PUT "Lorem ipsum dolor sit amet,  consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut";
      PUT "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores";
      PUT "et ea rebum. Stet clita kasd gubergren,  no sea takimata sanctus est Lorem ipsum dolor sit amet.";
   RUN;
   
   DATA _NULL_;
      FILE "&g_work./text1.bat";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt";
      PUT "ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo";
      PUT "dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut";
      PUT "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores";
      PUT "et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
   RUN;
%MEND _createtestfiles;

%MACRO _adaptToOS;
   %GLOBAL 
      assertText_script
      assertText_NotExistend
      assertText_CompTool
      assertText_OS
      assertText_mod1
      assertText_mod2
      assertText_work1
      assertText_work2
   ;
   /* Prepare macro variables to adapt to OS specific test */
   %IF %LOWCASE(%SYSGET(SASUNIT_HOST_OS)) EQ windows %THEN %DO;
      %LET assertText_script        =%sysfunc(translate(&g_sasunit_os.\assertText_fc.cmd,\,/));
      %LET assertText_NotExistend   =NotExistendFile.cmd;
      %LET assertText_CompTool      =fc;
      %LET assertText_OS            =Windows;
      %LET assertText_mod1          =/C;
      %LET assertText_mod2          =/W;
      %LET assertText_work1         =%sysfunc(translate(&g_work.\text1.txt,\,/));
      %LET assertText_work2         =%sysfunc(translate(&g_work.\text2.txt,\,/));
   %END;
   %ELSE %IF %LOWCASE(%SYSGET(SASUNIT_HOST_OS)) EQ linux %THEN %DO;
      %LET assertText_script        =%_abspath(&g_sasunit_os.,assertText_diff.sh);
      %LET assertText_NotExistend   =NotExistendFile.sh;
      %LET assertText_CompTool      =diff;
      %LET assertText_OS            =Linux;
      %LET assertText_mod1          =-i;
      %LET assertText_mod2          =-b;
      %LET assertText_work1         =%_abspath(&g_work.,text1.txt);
      %LET assertText_work2         =%_abspath(&g_work.,text2.txt);
   %END;
%MEND _adaptToOS;

/* create test files */
%_createtestfiles;
%_adaptToOS;

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */

%initTestcase(i_object   =asserttext.sas
             ,i_desc     =Texts with invalid input parameters
             )
%endTestcall()

%assertText(i_script            =&g_sasunit_os./&assertText_NotExistend.
           ,i_expected          =&assertText_work1.
           ,i_actual            =assertText_work2
           ,i_expected_shell_rc =0
           ,i_modifier          =
           ,i_desc              =Scipt does not exist
           );
           
   %markTest()
      %assertDBValue(tst,exp,0)
      %assertDBValue(tst,act,-2)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

   
   %assertLog (i_errors=0, i_warnings=0);

   %assertText(i_script            =&assertText_script.
              ,i_expected          =&g_work./DoesNotExist.txt
              ,i_actual            =assertText_work2
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =Comparison of texts
              );

   %markTest()
      %assertDBValue(tst,exp,0)
      %assertDBValue(tst,act,-3)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
      %assertLog (i_errors=0, i_warnings=0);

   %assertText(i_script            =&assertText_script.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./DoesNotExist.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =Comparison of texts
              );

   %markTest()
      %assertDBValue(tst,exp,0)
      %assertDBValue(tst,act,-4)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
      %assertLog (i_errors=0, i_warnings=0);
      
/* test case 2 ------------------------------------ */

%initTestcase(i_object   =asserttext.sas
             ,i_desc     =Successfull tests
             )
%endTestcall()

   %assertText(i_script            =&assertText_script.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text1_copy.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =Successful test: Files match
              );

   %assertText(i_script            =&assertText_script.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&assertText_work2.
              ,i_expected_shell_rc =1
              ,i_modifier          =
              ,i_desc              =%str(Files do not match, but difference expected)
              );
   %assertLog (i_errors=0, i_warnings=0);
   
%initTestcase(
             i_object   = asserttext.sas
            ,i_desc     = Specific tests with modifiers for &assertText_OS. compare tool &assertText_CompTool.
   )
%endTestcall()

/* test case 3 ------------------------------------ */
   %assertText(i_script            =&assertText_script.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text3.txt
              ,i_expected_shell_rc =1
              ,i_modifier          =
              ,i_desc              =%str(Files do not match, one letter in different case)
              );
              
   %assertText(i_script            =&assertText_script.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text3.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =&assertText_mod1.
              ,i_desc              =%str(Files do not match, one letter in different case, but &assertText_mod1. modifier used -> Comparision is OK)
              );

   %assertText(i_script            =&assertText_script.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text1_blanks.txt
              ,i_expected_shell_rc =1
              ,i_modifier          =
              ,i_desc              =%str(Files do not match, since extra blanks in text)
              );

   %assertText(i_script            =&assertText_script.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text1_blanks.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =&assertText_mod2.
              ,i_desc              =%str(Files do match, extra blanks in text, but compress blanks modifier &assertText_mod2. used)
              );

   %assertText(i_script            =&assertText_script.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text1.bat
              ,i_expected_shell_rc =0
              ,i_modifier          =&assertText_mod2.
              ,i_desc              =%str(Files do match, extra blanks in text, but compress blanks modifier &assertText_mod2. used)
              );
              
   %assertLog (i_errors=0, i_warnings=0);
%endTestcase();
/** \endcond */
