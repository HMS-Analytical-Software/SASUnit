/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of reportSASUnit.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
*/ /** \cond */ 


%initScenario(i_desc=%str(Test of reportSASUnit.sas));

%let workpath =%sysfunc(pathname(WORK));
%let rc       =%sysfunc (dcreate(doc, &workpath.));
%let rc       =%sysfunc (dcreate(testDoc, &workpath./doc));

%let G_REVISION  =N.N.N;
%let G_VERSION   =NNN;
%let G_DB_VERSION=N.N;

proc cimport file="&g_refdata./empty_test_db_tsu.cport" data=work.tsu;
run;
proc cimport file="&g_refdata./empty_test_db_exa.cport" data=work.exa;
run;
proc cimport file="&g_refdata./empty_test_db_scn.cport" data=work.scn;
run;
proc cimport file="&g_refdata./empty_test_db_cas.cport" data=work.cas;
run;
proc cimport file="&g_refdata./empty_test_db_tst.cport" data=work.tst;
run;

%*** Mocks erstellen ***;
%MACRO _reportPgmDoc(i_language      =
                    ,i_repdata       =
                    ,o_html          =
                    ,o_pdf           =
                    ,o_path          =
                    ,o_pgmdoc_sasunit=
                    ,i_style         =
                    ,i_srcFolder     =
                    ,o_pgmDocFolder  =
                    ,i_testDocFolder =
                    );

   %_issueInfoMessage (&g_currentLogger., ---->Doing _repoprtPgmDoc);
%MEND;

%MACRO _reportTreeHTML(i_repdata        =
                      ,o_html           =
                      ,o_pgmdoc         =
                      ,o_pgmdoc_sasunit =
                      ,i_style          =
                      ,o_pgmDocFolder   =
                      ,i_repdataexa     =
                      );
                      
   %_issueInfoMessage (&g_currentLogger., ---->Doing _repoprtTreeHtml);
%MEND;

%macro testcase(i_object=reportSASUnit.sas, i_desc=%str(Call without any scenarios in runSASUnit));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)
   %_switch();
   /* call */
   %reportSASUnit(o_html        =1
                 ,o_testcoverage=0
                 ,o_output      =&workpath.
                 );
   %_switch();
   %endTestcall()

   /* assert */
   %assertLog(i_errors=0, i_warnings=0);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

proc datasets lib=work nolist;
   delete
      tsu
      exa
      scn
      cas
      tst;
run;quit;

*** Mocks löschen ***;
proc catalog catalog=work.SASMACR entrytype=MACRO;
   delete _reportPgmDoc _reportTreeHTML;
run;quit;

%endScenario();
/** \endcond */