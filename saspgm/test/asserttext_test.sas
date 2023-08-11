/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertText.sas 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \test New test case with NOXCMD                  
*/ /** \cond */ 

%MACRO _createTestfiles;
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
%MEND _createTestfiles;

%initScenario(i_desc =Test of assertText.sas);

/* create test files */
%_createTestfiles;
%LET assertText_work1=&g_work./text1.txt;
%LET assertText_work2=&g_work./text2.txt;

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
%initTestcase(i_object   =assertText.sas
             ,i_desc     =Tests with invalid input parameters
             )
%endTestcall()

   %assertText(i_script            =
              ,i_expected          =
              ,i_actual            =
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =Script is not given
              );
              
   %markTest()
      %assertDBValue(tst,exp,0)
      %assertDBValue(tst,act,-2)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

   
   %assertText(i_script            =NotExistendFile.&g_osCmdFileSuffix.
              ,i_expected          =
              ,i_actual            =
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =Script does not exist
              );

   %markTest()
      %assertDBValue(tst,exp,0)
      %assertDBValue(tst,act,-3)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =
              ,i_actual            =
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =i_expected is not given
              );

   %markTest()
      %assertDBValue(tst,exp,0)
      %assertDBValue(tst,act,-4)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
      
   %assertText(i_expected          =&g_work./DoesNotExist.txt
              ,i_actual            =HUGO
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =i_expected does not exist
              );

   %markTest()
      %assertDBValue(tst,exp,0)
      %assertDBValue(tst,act,-5)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
      
   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&assertText_work1.
              ,i_actual            =
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =i_actual is not given
              );

   %markTest()
      %assertDBValue(tst,exp,0)
      %assertDBValue(tst,act,-6)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
      
   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./DoesNotExist.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =i_actual does not exist
              );

   %markTest()
      %assertDBValue(tst,exp,0)
      %assertDBValue(tst,act,-7)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
      
   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&assertText_work2.
              ,i_expected_shell_rc =
              ,i_modifier          =
              ,i_desc              =i_expected_shell_rc is not given
              );

   %markTest()
      %assertDBValue(tst,exp,)
      %assertDBValue(tst,act,-8)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertLog (i_errors=0, i_warnings=0);
%endTestcase();
      
/* test case 2 ------------------------------------ */
%initTestcase(i_object   =assertText.sas
             ,i_desc     =Successfull tests
             )
%endTestcall()

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text1_copy.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =Successful test: Files match
              );

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&assertText_work2.
              ,i_expected_shell_rc =1
              ,i_modifier          =
              ,i_desc              =%str(Files do not match, but difference expected)
              );

%assertLog (i_errors=0, i_warnings=0);
%endTestcase();

/* test case 3 ------------------------------------ */
%initTestcase(
             i_object   = assertText.sas
            ,i_desc     = Specific tests with modifiers for compare tool
   )
%endTestcall()

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text3.txt
              ,i_expected_shell_rc =1
              ,i_modifier          =
              ,i_desc              =%str(Files do not match, one letter in different case)
              );
              
   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text3.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =&g_assertTextIgnoreCase.
              ,i_desc              =%str(Files do not match, one letter in different case, but &g_assertTextIgnoreCase. modifier used -> Comparision is OK)
              );

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text1_blanks.txt
              ,i_expected_shell_rc =1
              ,i_modifier          =
              ,i_desc              =%str(Files do not match, since extra blanks in text)
              );

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text1_blanks.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =&g_assertTextCompressBlanks.
              ,i_desc              =%str(Files do match, extra blanks in text, but compress blanks modifier &g_assertTextCompressBlanks. used)
              );

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text1.bat
              ,i_expected_shell_rc =0
              ,i_modifier          =&g_assertTextCompressBlanks.
              ,i_desc              =%str(Files do match, extra blanks in text, but compress blanks modifier &g_assertTextCompressBlanks. used)
              );
              
%assertLog (i_errors=0, i_warnings=0);
%endTestcase();

%endScenario();
/** \endcond */