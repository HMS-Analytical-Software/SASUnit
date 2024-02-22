/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests for comparison.sas

   \version    \$Revision: GitBranch: feature/remove-os-dependend-code-in-test $ - KL: Removed hint "Windows only".\n
               Revision: 71 - KL: Test case can now be run under LINUX.
   \author     \$Author: landwich $
   \date       \$Date: 2024-02-22 11:13:53 (Do, 22. Februar 2024) $

   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 

%initScenario(i_desc=Tests for comparison.sas);

/* create test files */
%comparison;
   
/*-- Comparison with text files -------------------------------------------*/
%initTestcase(i_object=comparison.sas
             ,i_desc=Tests for comparison of different text files
             );
%endTestcall()

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&g_work./text1.txt
              ,i_actual            =&g_work./text1_copy.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =
              ,i_desc              =Successful test: Files match
              );

   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&g_work./text1.txt
              ,i_actual            =&g_work./text2.txt
              ,i_expected_shell_rc =1
              ,i_modifier          =
              ,i_desc              =%str(Files do not match, but difference expected)
              );
   %assertText(i_script            =&g_sasunit_os./assertText.&g_osCmdFileSuffix.
              ,i_expected          =&g_work./text1.txt
              ,i_actual            =&g_work./text2.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =&g_assertTextIgnoreCase.
              ,i_desc              =%str(Files do not match, one letter in different case, but &g_assertTextIgnoreCase. modifier used -> Comparision is OK)
              );
              
   %assertLog (i_errors=0, i_warnings=0);
%endTestcase
/*-- Comparison with image files -------------------------------------------
This example implementation of an image comparision uses Imagemagick.
For further information please consult http://www.imagemagick.org 
*/

%initTestcase(i_object=comparison.sas
             ,i_desc=Tests for comparison of different image files
             );
%endTestcall()
options printerpath=png nodate;
ods printer file="%sysfunc(pathname(work))/graph1.png";
   proc reg data=testdata1;
      model y = x / noprint;
      plot y * x / cframe=ligr;
   run;
ods printer file="%sysfunc(pathname(work))/graph1_copy.png";
   proc reg data=testdata1;
      model y = x / noprint;
      plot y * x / cframe=ligr;
   run;
ods printer file="%sysfunc(pathname(work))/graph2.png";
   proc reg data=testdata2;
      model y = x / noprint;
      plot y * x / cframe=ligr;; 
   run;
ods printer close;
   %assertImage(i_script             =&g_sasunit_os./assertImage.&g_osCmdFileSuffix.
               ,i_expected           =%sysfunc(pathname(work))/graph1.png  
               ,i_actual             =%sysfunc(pathname(work))/graph1_copy.png
               ,i_expected_shell_rc  =0                   
               ,i_modifier           =-metric ae                  
               ,i_desc               =Graphs do match
               );
               
   %assertImage(i_script             =&g_sasunit_os./assertImage.&g_osCmdFileSuffix.
               ,i_expected           =%sysfunc(pathname(work))/graph1.png  
               ,i_actual             =%sysfunc(pathname(work))/graph2.png
               ,i_expected_shell_rc  =1                   
               ,i_modifier           =-metric RMSE                  
               ,i_desc               =Graphs do not match%str(,) i_expected_shell_rc is set to 1
               );

   data class;
      set sashelp.class;
      if name="Barbara" then age=20;
   run;

   options printerpath=png nodate;
   footnote .j=r "01/07/2015";
   ods printer file="%sysfunc(pathname(work))/class1.png";
      proc print data=sashelp.class;
      run;
   ods printer file="%sysfunc(pathname(work))/class2.png";
      proc print data=class;
      run;
   footnote .j=r "02/07/2015";
   ods printer file="%sysfunc(pathname(work))/class3.png";
      proc print data=sashelp.class;
      run;
   footnote;
   ods printer close;
   
   %assertImage(i_script             =&g_sasunit_os./assertImage.&g_osCmdFileSuffix.
               ,i_expected           =%sysfunc(pathname(work))/class1.png  
               ,i_actual             =%sysfunc(pathname(work))/class2.png
               ,i_expected_shell_rc  =1                   
               ,i_modifier           =-metric RMSE                  
               ,i_desc               =Graphs do not match%str(,) i_expected_shell_rc is set to 1
               );
               
   %assertImage(i_script             =&g_sasunit_os./assertImage.&g_osCmdFileSuffix.
               ,i_expected           =%sysfunc(pathname(work))/class1.png  
               ,i_actual             =%sysfunc(pathname(work))/class3.png
               ,i_expected_shell_rc  =0
               ,i_threshold          =60
               ,i_modifier           =-metric ae /* -metric ae counts the absolute amount of different pixels */
               ,i_desc               =Graphs do not match%str(,) i_modifier set to "-metric ae" and i_threshold allowing 60 pixels to be different
               );

   %assertLog (i_errors=0, i_warnings=0);
%endTestcase

/*-- Assert external: word count example -------------------------------------*/
%initTestcase(i_object   = comparison.sas
             ,i_desc     = Word count example with assertExternal
             );
%endTestcall()

   %let l_file=%_adaptSASUnitPathToOS(&g_work./text1.txt);
   %assertExternal (i_script             =&g_sasunit_os./assertExternal_wordcount.&g_osCmdFileSuffix.
                   ,i_parameters         =&l_file. "Lorem" "4"
                   ,i_expected_shell_rc  =0
                   ,i_desc               =Word count of "Lorem" equals 4
                   );
                   
   %assertExternal (i_script             =&g_sasunit_os./assertExternal_wordcount.&g_osCmdFileSuffix.
                   ,i_parameters         =&l_file. "Lorem" "3"
                   ,i_expected_shell_rc  =1
                   ,i_desc               =%str(Word count of "Lorem" equals 4, but expected count is 3, so i_expected_shell_rc must be 1 to make test green)
                   );
  
   %assertLog (i_errors=0, i_warnings=0);
%endTestcase

proc datasets lib=work nolist;
   delete testdata1 testdata2 class;
run;
quit;

%endScenario();
/** \endcond */ 