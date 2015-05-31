/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Example for cross reference reports


\version    \$Revision: 315 $
\author     \$Author: klandwich $
\date       \$Date: 2014-02-28 10:25:18 +0100 (Fr, 28 Feb 2014) $
\sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
\sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/example/saspgm/generate_test.sas $
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

/*-- Testcase 1 ---------------------------------------------*/
%initTestcase(i_object=CrossReferenceTest1.sas, i_desc=example for cross refence reports)

ods listing;
%CrossReferenceTest1;

%endTestcall()
%assertLog(i_errors=0, i_warnings=0);
%endTestcase()

/*-- Testcase 2 ---------------------------------------------*/
%initTestcase(i_object=CrossReferenceTest2.sas, i_desc=example for cross refence reports)

ods listing;
%CrossReferenceTest2(i_obs=8
                    ,i_title=My Second Test Case
                    );

%endTestcall()
%assertLog(i_errors=0, i_warnings=0);
%endTestcase()

/*-- Testcase 3 ---------------------------------------------*/
%initTestcase(i_object=CrossReferenceTest3.sas, i_desc=example for cross refence reports)

ods listing;
%CrossReferenceTest3 (5);

%endTestcall()
%assertLog(i_errors=0, i_warnings=0);
%endTestcase()

/*-- Testcase 4 ---------------------------------------------*/
%initTestcase(i_object=CrossReferenceTest4.sas, i_desc=example for cross refence reports)

ods listing;
%put result=%CrossReferenceTest4 (var1 =2
                                 ,var2 =9
                                 );

%endTestcall()
%assertLog(i_errors=0, i_warnings=0);
%endTestcase()

/** \endcond */
