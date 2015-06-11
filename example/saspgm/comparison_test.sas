/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests for comparison.sas

\version    \$Revision: 315 $ - KL: Removed hint "Windows only".\n
            Revision: 71 - KL: Test case can now be run under LINUX.
\author     \$Author: klandwich $
\date       \$Date: 2014-02-28 10:25:18 +0100 (Fr, 28 Feb 2014) $
\sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
\sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/example/saspgm/regression_test.sas $
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

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
      %LET assertText_script        =%sysfunc(translate(&g_testdata.\assertText_fc.cmd,\,/));
      %LET assertImage_script       =%sysfunc(translate(&g_testdata.\assertImage.cmd,\,/));
      %LET assertExternal_script    =%sysfunc(translate(&g_testdata.\assertExternal_cnt.cmd,\,/));
      %LET assertText_CompTool      =fc;
      %LET assertText_OS            =Windows;
      %LET assertText_mod1          =/C;
      %LET assertText_mod2          =/W;
      %LET assertText_work1         =%sysfunc(translate(&g_work.\text1.txt,\,/));
      %LET assertText_work2         =%sysfunc(translate(&g_work.\text2.txt,\,/));
   %END;
   %ELSE %IF %LOWCASE(%SYSGET(SASUNIT_HOST_OS)) EQ linux %THEN %DO;
      %LET assertText_script        =%_abspath(&g_testdata.,assertText_diff.sh);
      %LET assertImage_script       =%_abspath(&g_testdata.,assertImage.sh);
      %LET assertExternal_script    =%_abspath(&g_testdata.,assertExternal_wc.sh);
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

/*-- Comparison with image files -------------------------------------------*/
%initTestcase(i_object=comparison.sas
             ,i_desc=Tests for comparison of different image files
             );
%endTestcall()
options printerpath=png nodate;
ods html close;
ods printer file="%sysfunc(pathname(work))/graph1.png";
   proc reg data=testdata1;
      model y = x / noprint;
      plot y * x / cframe=ligr;; 
   run;
ods printer file="%sysfunc(pathname(work))/graph1_copy.png";
   proc reg data=testdata1;
      model y = x / noprint;
      plot y * x / cframe=ligr;; 
   run;
ods printer file="%sysfunc(pathname(work))/graph2.png";
   proc reg data=testdata2;
      model y = x / noprint;
      plot y * x / cframe=ligr;; 
   run;
ods printer close;
ods html;
%assertImage(i_script             =&assertImage_script.
            ,i_expected           =%sysfunc(pathname(work))/graph1.png  
            ,i_actual             =%sysfunc(pathname(work))/graph1_copy.png
            ,i_expected_shell_rc  =0                   
            ,i_modifier           =-metric RMSE                  
            ,i_threshold          =
            ,i_desc               =Graphs do match
            );
            
%assertImage(i_script             =&assertImage_script.
            ,i_expected           =%sysfunc(pathname(work))/graph1.png  
            ,i_actual             =%sysfunc(pathname(work))/graph2.png
            ,i_expected_shell_rc  =0                   
            ,i_modifier           =-metric RMSE                  
            ,i_threshold          =
            ,i_desc               =Graphs do not match
            );

   data class;
      set sashelp.class;
      if name="Barbara" then age=20;
   run;

   options printerpath=png nodate;
   ods html close;
   ods printer file="%sysfunc(pathname(work))/class1.png";
      proc print data=sashelp.class;
      run;
   ods printer file="%sysfunc(pathname(work))/class2.png";
      proc print data=class;
      run;
   ods printer close;
   ods html;
   
%assertImage(i_script             =&assertImage_script.
            ,i_expected           =%sysfunc(pathname(work))/class1.png  
            ,i_actual             =%sysfunc(pathname(work))/class2.png
            ,i_expected_shell_rc  =0                   
            ,i_modifier           =-metric RMSE                  
            ,i_threshold          =
            ,i_desc               =Graphs do not match
            );

%assertLog (i_errors=0, i_warnings=0);

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
                ,i_threshold          =NONE
                );
                
%assertExternal (i_script             =&assertExternal_script.
                ,i_expected           =&assertText_work1.
                ,i_actual             =3
                ,i_expected_shell_rc  =1
                ,i_expectedIsPath     =Y
                ,i_desc               =%str(Word count of "Lorem" equals 4, but i_actual=3, so i_expected_shell_rc must be 1 to make test green)
                ,i_threshold          =NONE
                );
   

/** \endcond */
