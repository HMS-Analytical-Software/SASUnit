/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests for comparison.sas

   \version    \$Revision$ - KL: Removed hint "Windows only".\n
               Revision: 71 - KL: Test case can now be run under LINUX.
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

*/ /** \cond */ 

%initScenario(i_desc=Tests for comparison.sas);

%MACRO _adaptToOS;
   %GLOBAL 
      assertText_script
      assertImage_script
      assertExternal_script
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
      %LET assertImage_script       =%sysfunc(translate(&g_sasunit_os.\assertImage.cmd,\,/));
      %LET assertExternal_script    =%sysfunc(translate(&g_sasunit_os.\assertExternal_cnt.cmd,\,/));
      %LET assertText_CompTool      =fc;
      %LET assertText_OS            =Windows;
      %LET assertText_mod1          =/C;
      %LET assertText_mod2          =/W;
      %LET assertText_work1         =%sysfunc(translate(&g_work.\text1.txt,\,/));
      %LET assertText_work2         =%sysfunc(translate(&g_work.\text2.txt,\,/));
   %END;
   %ELSE %IF %LOWCASE(%SYSGET(SASUNIT_HOST_OS)) EQ linux %THEN %DO;
      %LET assertText_script        =%_abspath(&g_sasunit_os.,assertText_diff.sh);
      %LET assertImage_script       =%_abspath(&g_sasunit_os.,assertImage.sh);
      %LET assertExternal_script    =%_abspath(&g_sasunit_os.,assertExternal_wc.sh);
      %LET assertText_CompTool      =diff;
      %LET assertText_OS            =Linux;
      %LET assertText_mod1          =-i;
      %LET assertText_mod2          =-b;
      %LET assertText_work1         =%_abspath(&g_work.,text1.txt);
      %LET assertText_work2         =%_abspath(&g_work.,text2.txt);
   %END;
%MEND _adaptToOS;

/* create test files */
%comparison;
%_adaptToOS;
   
/*-- Comparison with text files -------------------------------------------*/
%initTestcase(i_object=comparison.sas
             ,i_desc=Tests for comparison of different text files
             );
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
   %assertText(i_script            =&assertText_script.
              ,i_expected          =&assertText_work1.
              ,i_actual            =&g_work./text2.txt
              ,i_expected_shell_rc =0
              ,i_modifier          =&assertText_mod1.
              ,i_desc              =%str(Files do not match, one letter in different case, but &assertText_mod1. modifier used -> Comparision is OK)
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
   %assertImage(i_script             =&assertImage_script.
               ,i_expected           =%sysfunc(pathname(work))/graph1.png  
               ,i_actual             =%sysfunc(pathname(work))/graph1_copy.png
               ,i_expected_shell_rc  =0                   
               ,i_modifier           =-metric ae                  
               ,i_desc               =Graphs do match
               );
               
   %assertImage(i_script             =&assertImage_script.
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
   
   %assertImage(i_script             =&assertImage_script.
               ,i_expected           =%sysfunc(pathname(work))/class1.png  
               ,i_actual             =%sysfunc(pathname(work))/class2.png
               ,i_expected_shell_rc  =1                   
               ,i_modifier           =-metric RMSE                  
               ,i_desc               =Graphs do not match%str(,) i_expected_shell_rc is set to 1
               );
               
   %assertImage(i_script             =&assertImage_script.
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

   %assertExternal (i_script             =&assertExternal_script.
                   ,i_expected           =&assertText_work1.
                   ,i_actual             =4
                   ,i_expected_shell_rc  =0
                   ,i_expectedIsPath     =Y
                   ,i_desc               =Word count of "Lorem" equals 4
                   );
                   
   %assertExternal (i_script             =&assertExternal_script.
                   ,i_expected           =&assertText_work1.
                   ,i_actual             =3
                   ,i_expected_shell_rc  =1
                   ,i_expectedIsPath     =Y
                   ,i_desc               =%str(Word count of "Lorem" equals 4, but i_actual=3, so i_expected_shell_rc must be 1 to make test green)
                   );
  
   %assertLog (i_errors=0, i_warnings=0);
%endTestcase

proc datasets lib=work nolist;
   delete testdata1 testdata2 class;
run;
quit;

%endScenario();
/** \endcond */