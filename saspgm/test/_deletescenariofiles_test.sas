/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of _deleteScenarioFiles.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */

/* Create test files */
%MACRO _deleteScenarioFiles_crtTstFls();
   %LOCAL l_abs_path;
   %LET l_abs_path = %_abspath(&g_root, &g_target);
   
   %*** Create tables needed ***;
   PROC SQL;
      create table work.scn(COMPRESS=CHAR)
      (                                          
          scn_id  INT FORMAT=z3.   /* number of scenario */
      );
      create table work.scenariosToRun
      (                                          
          scn_id  INT FORMAT=z3.,   /* number of scenario */
          dorun   INT
      );
   QUIT;

   PROC SQL;
      insert into work.scn(scn_id)
      values(1)
      values(2)
      values(3)
      ;
      insert into work.scenariosToRun(scn_id, dorun)
      values(1, 1)
      values(2, 0)
      values(3, 0)
      values(4, 1)
      ;
   QUIT;

   %*** Create folder structure for the test ***;  
   %_mkdir(%sysfunc(pathname(work))/log);
   %_mkdir(%sysfunc(pathname(work))/rep);
   %_mkdir(%sysfunc(pathname(work))/tst);
   %_mkdir(%sysfunc(pathname(work))/tst/_001_005_004_assertlibrary);
   %_mkdir(%sysfunc(pathname(work))/tst/_001_009_001_assertlibrary);
   %_mkdir(%sysfunc(pathname(work))/tst/_002_002_001_assertreport);
   %_mkdir(%sysfunc(pathname(work))/tst/_003_002_001_assertreport);
 
   %*** Create test files ***;
   %DO i=1 %TO 3;
      %*** Create "/log" files ***;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/log/00&i..log";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/log/00&i..tcg";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/log/00&i._003.log";
         PUT "hugo&i.";
      RUN;

      %*** Create "/rep" files ***;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/rep/cas_00&i._004.html";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/rep/00&i._004_006.html";
         PUT "hugo&i.";
      RUN;
      
      %*** Create "/tst" files ***;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/tst/00&i..lst";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/tst/00&i._003.lst";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/tst/_001_005_004_assertlibrary/test.sas7bdat";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/tst/_001_009_001_assertlibrary/test1.sas7bdat";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/tst/_002_002_001_assertreport/test.sas7bdat";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/tst/_001_005_004_assertlibrary/test1.sas7bdat";
         PUT "hugo&i.";
      RUN;  
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/tst/_003_002_001_assertreport/test.sas7bdat";
         PUT "hugo&i.";
      RUN;      
   %END;
%MEND _deleteScenarioFiles_crtTstFls;

%initScenario (i_desc=Test of _deleteScenarioFiles.sas)

%*** Initialize/create test files ***;
%_deletescenariofiles_crtTstFls;

/* test case 1 ------------------------------------ */
%initTestcase(i_object=_deleteScenarioFiles.sas, i_desc=Test the deletion of scenario files and folders);
/*-- switch to example database --------------------*/
%_switch();
%_deletescenariofiles(i_scenariosToRun=scenariosToRun
                     );
/*-- switch to real database -----------------------*/
%_switch();
%endTestcall()

%markTest()
   /* Folder Test */
   %assertEquals(i_actual=%_existDir(%sysfunc(pathname(work))/tst/_001_005_004_assertlibrary),i_expected=0, i_desc=Test if folders tst/_001* exists%str(,) folder to delete _001_005_004_assertlibrary);
   %assertEquals(i_actual=%_existDir(%sysfunc(pathname(work))/tst/_001_009_001_assertlibrary),i_expected=0, i_desc=Test if folders tst/_001* exists%str(,) folder to delete _001_009_001_assertlibrary);
   %assertEquals(i_actual=%_existDir(%sysfunc(pathname(work))/tst/_002_002_001_assertreport), i_expected=1, i_desc=Test if folders tst/_001* exists%str(,) folder not to delete _002_002_001_assertreport);
   %assertEquals(i_actual=%_existDir(%sysfunc(pathname(work))/tst/_003_002_001_assertreport), i_expected=1, i_desc=Test if folders tst/_001* exists%str(,) folder not to delete _003_002_001_assertreport);
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/tst/001.lst)),          i_expected=0, i_desc=Test if file tst/001.lst exists%str(,) file to delete 001.lst);
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/tst/001_003.lst)),      i_expected=0, i_desc=Test if file tst/001_*.lst exists%str(,) file to delete 001_003.lst);
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/tst/002.lst)),          i_expected=1, i_desc=Test if file tst/002.lst exists%str(,) file not to delete 002.lst);
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/tst/002_003.lst)),      i_expected=1, i_desc=Test if file tst/002_*.lst exists%str(,) file not to delete 002_003.lst);
   /* Folder Log */
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/log/001.log)),          i_expected=0, i_desc=Test if files log/_001* exists%str(,) file to delete 001.log);  
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/log/001.tcg)),          i_expected=0, i_desc=Test if files log/_001* exists%str(,) file to delete 001.tcg);
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/log/001_003.log)),      i_expected=0, i_desc=Test if files log/_001* exists%str(,) file to delete 001_003.log);
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/log/003.log)),          i_expected=1, i_desc=Test if files log/_001* exists%str(,) file not to delete 003.log);
   /* Folder Rep */
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/rep/001_004_006.html)), i_expected=0, i_desc=Test if files rep/001* exists%str(,) file to delete 001_004_006.html);  
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/rep/002_004_006.html)), i_expected=1, i_desc=Test if files rep/002* exists%str(,) file not to delete 002_004_006.html);  
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/rep/003_004_006.html)), i_expected=1, i_desc=Test if files rep/003* exists%str(,) file not to delete 003_004_006.html);      
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/rep/cas_001_004.html)), i_expected=0, i_desc=Test if files rep/cas_001* exists%str(,) file to delete cas_001_004.html);  
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/rep/cas_002_004.html)), i_expected=1, i_desc=Test if files rep/cas_002* exists%str(,) file not to delete cas_002_004.html);
   %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/rep/cas_003_004.html)), i_expected=1, i_desc=Test if files rep/cas_003* exists%str(,) file not to delete cas_003_004.html);
%endTestcase(i_assertLog=0)

%endScenario();
/** \endcond */