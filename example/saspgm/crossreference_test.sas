/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Example for cross reference reports


   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

*/ /** \cond */ 

%initScenario(i_desc=Example for cross reference reports);

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


%endScenario();
/** \endcond */