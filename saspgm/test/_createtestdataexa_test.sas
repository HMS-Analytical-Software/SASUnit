/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _createtestdataexa.sas

   \version    \$Revision: 659 $
   \author     \$Author: klandwich $
   \date       \$Date: 2019-04-25 16:01:34 +0200 (Do, 25 Apr 2019) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_createrepdata_test.sas $
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _createtestdataexa.sas);

%macro testcase(i_object=_createtestdataexa.sas, i_desc=%str(Correct call));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */
   options dlcreatedir;
   libname _target "%sysfunc(pathname(WORK))/_target";
   libname _test "%sysfunc(pathname(WORK))/_test";
   options nodlcreatedir;

   data _test.tsu;
      set target.tsu;
      stop;
   run;
   data _test.scn;
      set target.scn;
      stop;
   run;
   data _test.cas;
      set target.cas;
      stop;
   run;
   data _test.tst;
      set target.tst;
      stop;
   run;
   data _test.exa;
      set target.exa;
      stop;
   run;

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_createtestdataexa(libref=_target);
   %endTestcall()

   /* assert */
   %assertLog(i_errors=0, i_warnings=0);
   %assertColumns(i_expected=_test.exa
                 ,i_actual  =_target.exa
                 ,i_desc    =Compare exa table
                 );

   proc datasets lib=_target kill memtype=data nodetails nolist;
   run;
   quit;
   proc datasets lib=_test kill memtype=data nodetails nolist;
   run;
   quit;

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%endScenario();
/** \endcond */