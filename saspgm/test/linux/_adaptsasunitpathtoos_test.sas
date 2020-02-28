/** \file
   \ingroup    SASUNIT_TEST_OS_LINUX

   \brief      Test of _adaptsasunitpathtoos.sas

   \version    \$Revision: 659 $
   \author     \$Author: klandwich $
   \date       \$Date: 2019-04-25 16:01:34 +0200 (Do, 25 Apr 2019) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_createrepdata_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _adaptsasunitpathtoos.sas);

%macro testcase(i_object=_adaptsasunitpathtoos.sas, i_desc=%str(Call with simple paths));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %let l_sasunitPath1 = %_adaptSASUnitPathToOS(/var/opt/TEMP/Test/);
   %let l_sasunitPath2 = %_adaptSASUnitPathToOS(/var/opt/TEMP/Test);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=0);
   %assertEquals  (i_expected=/var/opt/TEMP/Test/
                  ,i_actual  =&l_sasunitPath1.
                  ,i_desc    =Path with ending \ is changed correctly
                  );
   %assertEquals  (i_expected=/var/opt/TEMP/Test/
                  ,i_actual  =&l_sasunitPath2.
                  ,i_desc    =Path without ending \ is changed correctly
                  );
                  
   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_adaptsasunitpathtoos.sas, i_desc=%str(Call with paths containing wildcards));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %let l_sasunitPath1 = %_adaptSASUnitPathToOS(/var/opt/TEMP/Test/%str(*)_test.sas);
   %let l_sasunitPath2 = %_adaptSASUnitPathToOS(/var/opt/TEMP/Test/%str(*));

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=0);
   %assertEquals  (i_expected=/var/opt/TEMP/Test/%str(*)_test.sas
                  ,i_actual  =&l_sasunitPath1.
                  ,i_desc    =Path with wildcard %str(*) inbetween is changed correctly
                  );
   %assertEquals  (i_expected=/var/opt/TEMP/Test/%str(*)
                  ,i_actual  =&l_sasunitPath2.
                  ,i_desc    =Path with wildcard %str(*) at the end is changed correctly
                  );
                  
   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_adaptsasunitpathtoos.sas, i_desc=%str(Call with paths containing blanks));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %let l_sasunitPath1 = %_adaptSASUnitPathToOS(/var/opt/SAS Temporary\\\ Files/Test/);
   %let l_sasunitPath2 = %_adaptSASUnitPathToOS(/var/opt/SAS\\ Temporary\ Files/Test);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=0);
   %assertEquals  (i_expected=/var/opt/SAS\ Temporary\\\ Files/Test/
                  ,i_actual  =&l_sasunitPath1.
                  ,i_desc    =Path with blank changed correctly
                  );
   %assertEquals  (i_expected=/var/opt/SAS\\ Temporary\ Files/Test
                  ,i_actual  =&l_sasunitPath2.
                  ,i_desc    =Path with blank changed correctly
                  );
                  
   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_adaptsasunitpathtoos.sas, i_desc=%str(Call with paths containing blanks and wildcards));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %let l_sasunitPath1 = %_adaptSASUnitPathToOS(/var/opt/SAS Temporary\\\ Files/Test/%str(*)_test.sas);
   %let l_sasunitPath2 = %_adaptSASUnitPathToOS(/var/opt/SAS\\ Temporary\ Files/Test/%str(*));

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=0);
   %assertEquals  (i_expected=/var/opt/SAS\ Temporary\\\ Files/Test/%str(*)_test.sas
                  ,i_actual  =&l_sasunitPath1.
                  ,i_desc    =Path with blank and wildcard %str(*) inbetween is changed correctly
                  );
   %assertEquals  (i_expected=/var/opt/SAS\\ Temporary\ Files/Test/%str(*)
                  ,i_actual  =&l_sasunitPath2.
                  ,i_desc    =Path with blank and wildcard %str(*) at the end is changed correctly
                  );
                  
   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;


%endScenario();
/** \endcond */
