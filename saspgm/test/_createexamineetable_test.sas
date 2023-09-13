/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _createExamineeTable.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \test create another test case with CrossRefSASUnit or PgmDocSASUnit
*/ /** \cond */ 

%initScenario (i_desc=Test of _createExamineeTable.sas);


%macro testcase(i_object=_createExamineeTable.sas, i_desc=%str(Test with correct call));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */
   data work.exa;
      set target.exa;
      stop;
   run;
   data work.exa_expected;
      set target.exa 
         %if (&g_crossrefsasunit. = 0) %then %do;
                (where=(exa_auton >=2))
         %end;
         %else %do;
                (where=(exa_auton >= 0))
         %end;
      ;
   run;

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %_switch();
   %let g_root=&save_root.;
   %_createExamineeTable;
   %_switch();

   %endTestcall()

   /* assert */
   proc sort data=work.exa_expected;
      by exa_id;
   run;
   proc sort data=work.exa;
      by exa_id;
   run;
   %assertColumns(i_expected=work.exa_expected
                 ,i_actual  =work.exa
                 ,i_desc    =Identical except test coverage
                 ,i_exclude =exa_tcg_pct
                 );

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

proc datasets lib=work nolist;
   delete exa exa_expected;
run;quit;

%endScenario();
/** \endcond */