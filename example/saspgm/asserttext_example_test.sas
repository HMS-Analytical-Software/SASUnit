/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST 

   \brief      Test examples for assertText.sas 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
*/ /** \cond */ 

%initScenario(i_desc=Test examples for assertText.sas);

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

/* create test files */
%_createtestfiles;

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
%initTestcase(
             i_object   = asserttext.sas
            ,i_desc     = Specific tests with modifiers for assertText
   )
%endTestcall()

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&g_work./text1.txt
              ,i_actual            =&g_work./text3.txt
              ,i_expected_shell_rc =1
              ,i_modifier          =
              ,i_desc              =%str(Files do not match, one letter in different case. Difference is expected so test case will succeed.)
              );
              
   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&g_work./text1.txt
              ,i_actual            =&g_work./text3.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =&g_assertTextIgnoreCase.
              ,i_desc              =%str(Files do not match, one letter in different case, but &g_assertTextIgnoreCase. modifier used -> Comparision is OK)
              );

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&g_work./text1.txt
              ,i_actual            =&g_work./text1_blanks.txt
              ,i_expected_shell_rc =1
              ,i_modifier          =
              ,i_desc              =%str(Files do not match, since extra blanks in text)
              );

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&g_work./text1.txt
              ,i_actual            =&g_work./text1_blanks.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =&g_assertTextCompressBlanks.
              ,i_desc              =%str(Files do match, extra blanks in text, but compress blanks modifier &g_assertTextCompressBlanks. used)
              );

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&g_work./text1.txt
              ,i_actual            =&g_work./text1.bat
              ,i_expected_shell_rc =0
              ,i_modifier          =&g_assertTextCompressBlanks.
              ,i_desc              =%str(Files do match, extra blanks in text, but compress blanks modifier &g_assertTextCompressBlanks. used)
              );
              
   %assertLog (i_errors=0, i_warnings=0);
%endTestcase();

%endScenario();
/** \endcond */