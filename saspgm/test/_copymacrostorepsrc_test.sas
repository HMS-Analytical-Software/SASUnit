/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _copyMacrosToRepSrc.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _copyMacrosToRepSrc.sas);

%let workpath          =%sysfunc(pathname(WORK));
%let w_sasunit_path    =&workpath./saspgm;
%let w_sasunit_os_path =&w_sasunit_path./os;
%let w_macro_path      =&workpath./macro;
%let w_macro2_path     =&workpath./macro2;
%let w_macro3_path     =&workpath./macro3;
%let w_scn_path        =&workpath./scn;

%let rc=%sysfunc (dcreate(saspgm,  &workpath.));
%let rc=%sysfunc (dcreate(os,      &w_sasunit_path.));
%let rc=%sysfunc (dcreate(macro,   &workpath.));
%let rc=%sysfunc (dcreate(macro2,  &workpath.));
%let rc=%sysfunc (dcreate(macro3,  &workpath.));
%let rc=%sysfunc (dcreate(scn,     &workpath.));
%let rc=%sysfunc (dcreate(doc,     &workpath.));
%let rc=%sysfunc (dcreate(testDoc, &workpath./doc));

data _NULL_;
   file "&w_sasunit_path./SASUnit_Macro.sas";
   put "/* Empty File for copying */";
run;
data _NULL_;
   file "&w_sasunit_os_path./SASUnit_OS_Macro.sas";
   put "/* Empty File for copying */";
run;
data _NULL_;
   file "&w_macro_path./autocall_macro_1.sas";
   put "/* Empty File for copying */";
run;
data _NULL_;
   file "&w_macro2_path./autocall_macro_2.sas";
   put "/* Empty File for copying */";
run;
data _NULL_;
   file "&w_macro3_path./macro_outside_autocall.sas";
   put "/* Empty File for copying */";
run;
data _NULL_;
   file "&w_macro2_path./Testscenario_inside_autocall.sas";
   put "/* Empty File for copying */";
run;
data _NULL_;
   file "&w_scn_path./Testscenario_outside_autocall.sas";
   put "/* Empty File for copying */";
run;

data work.exa;
   set target.exa (obs=1);
   exa_id       = 0;
   exa_id+1;
   exa_auton    = 0;
   exa_pgm      = "SASUnit_Marco.sas";
   exa_filename = "&w_sasunit_path./SASUnit_Macro.sas";
   exa_path     = "saspgm/SASUnit_Marco.sas";
   output;
   exa_id+1;
   exa_auton    = 1;
   exa_pgm      = "SASUnit_OS_Marco.sas";
   exa_filename = "&w_sasunit_os_path./SASUnit_OS_Macro.sas";
   exa_path     = "saspgm/os/SASUnit_OS_Marco.sas";
   output;
   exa_id+1;
   exa_auton    = 2;
   exa_pgm      = "autocall_macro_1.sas";
   exa_filename = "&w_macro_path./autocall_macro_1.sas";
   exa_path     = "macro/autocall_macro_1.sas";
   output;
   exa_id+1;
   exa_auton    = 3;
   exa_pgm      = "autocall_macro_2.sas";
   exa_filename = "&w_macro2_path./autocall_macro_2.sas";
   exa_path     = "macro2/autocall_macro_2.sas";
   output;
   exa_id+1;
   exa_auton    = 3;
   exa_pgm      = "Testscenario_inside_autocall.sas";
   exa_filename = "&w_macro2_path./Testscenario_inside_autocall.sas";
   exa_path     = "macro2/Testscenario_inside_autocall.sas";
   output;
   exa_id+1;
   exa_auton    = .;
   exa_pgm      = "macro_outside_autocall.sas";
   exa_filename = "&w_macro3_path./macro_outside_autocall.sas";
   exa_path     = "macro3/macro_outside_autocall.sas";
   output;
run;

data work.scn;
   set target.scn (obs=1);
   scn_id       = 1;
   scn_path     = "scn/Testscenario_outside_autocall.sas";
   scn_desc     = "Blah Blubb Blubber";
   scn_start    = 1;
   output;
   scn_id       = 2;
   scn_path     = "macro2/Testscenario_inside_autocall.sas";
   scn_desc     = "Blah Blubb Blubber";
   scn_start    = 1;
   output;
run;

%let _filename=&workpath./doc/testDoc/src/00/SASUnit_Marco.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/01/SASUnit_OS_Marco.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/02/autocall_macro_1.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/03/autocall_macro_2.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/99/macro_outside_autocall.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/03/Testscenario_inside_autocall.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/scn/Testscenario_inside_autocall.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/scn/Testscenario_outside_autocall.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);

%initTestcase(i_object=_copyMacrosToRepSrc.sas, i_desc=Test without SASUnit macros pgm_doc_sasunit=0);
%_switch();
%_copyMacrosToRepSrc(o_pgmdoc_sasunit=0);
%_switch();
%endTestcall;

%let _filename=&workpath./doc/testDoc/src/00/SASUnit_Marco.sas;
%assertEquals(i_expected=0
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must not exist
             );
%let _filename=&workpath./doc/testDoc/src/01/SASUnit_OS_Marco.sas;
%assertEquals(i_expected=0
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must not exist
             );
%let _filename=&workpath./doc/testDoc/src/02/autocall_macro_1.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );
%let _filename=&workpath./doc/testDoc/src/03/autocall_macro_2.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );
%let _filename=&workpath./doc/testDoc/src/99/macro_outside_autocall.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );
%let _filename=&workpath./doc/testDoc/src/03/Testscenario_inside_autocall.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must not exist
             );
%let _filename=&workpath./doc/testDoc/src/scn/scn_001.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );
%let _filename=&workpath./doc/testDoc/src/scn/scn_002.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );

%endTestcase;

%let _filename=&workpath./doc/testDoc/src/00/SASUnit_Marco.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/01/SASUnit_OS_Marco.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/02/autocall_macro_1.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/03/autocall_macro_2.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/99/macro_outside_autocall.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/03/Testscenario_inside_autocall.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/scn/Testscenario_inside_autocall.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);
%let _filename=&workpath./doc/testDoc/src/scn/Testscenario_outside_autocall.sas;
%put Deleting file &_filename.: %_delfile(&_filename.);

%initTestcase(i_object=_copyMacrosToRepSrc.sas, i_desc=Test including SASUnit macros pgm_doc_sasunit=1);
%_switch();
%_copyMacrosToRepSrc(o_pgmdoc_sasunit=1);
%_switch();
%endTestcall;

%let _filename=&workpath./doc/testDoc/src/00/SASUnit_Marco.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );
%let _filename=&workpath./doc/testDoc/src/01/SASUnit_OS_Marco.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );
%let _filename=&workpath./doc/testDoc/src/02/autocall_macro_1.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );
%let _filename=&workpath./doc/testDoc/src/03/autocall_macro_2.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );
%let _filename=&workpath./doc/testDoc/src/99/macro_outside_autocall.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );
%let _filename=&workpath./doc/testDoc/src/03/Testscenario_inside_autocall.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must not exist
             );
%let _filename=&workpath./doc/testDoc/src/scn/scn_001.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );
%let _filename=&workpath./doc/testDoc/src/scn/scn_002.sas;
%assertEquals(i_expected=1
             ,i_actual  =%sysfunc(fileexist(&_filename.))
             ,i_desc    =File &_filename. must exist
             );

%endTestcase;

proc cimport file="&g_refdata./empty_test_db_scn.cport" data=work.scn;
run;

%initTestcase(i_object=_copyMacrosToRepSrc.sas, i_desc=Test with 'empty' scenariofile);
%_switch();
%_copyMacrosToRepSrc(o_pgmdoc_sasunit=1);
%_switch();
%endTestcall;

%assertLog(i_errors  =0
          ,i_warnings=0
          );

%endTestcase;

proc datasets lib=work nolist;
   delete 
      scn
      exa
   ;
run;quit;

%endScenario();
/** \endcond */