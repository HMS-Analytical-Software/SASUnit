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
   %_mkdir(&g_tsuScnLogFolder.);
   %_mkdir(&g_tsuReportFolder.);
   %_mkdir(&g_tsuReportFolder./tempDoc);
   %_mkdir(&g_tsuReportFolder./tempDoc/_001_005_004_assertlibrary);
   %_mkdir(&g_tsuReportFolder./tempDoc/_001_009_001_assertlibrary);
   %_mkdir(&g_tsuReportFolder./tempDoc/_002_002_001_assertreport);
   %_mkdir(&g_tsuReportFolder./tempDoc/_003_002_001_assertreport);
   %_mkdir(&g_tsuReportFolder./testDoc);
   %_mkdir(&g_tsuReportFolder./testDoc/testCoverage);
 
   %*** Create test files ***;
   %DO i=1 %TO 3;
      %*** Create scenario log files ***;
      DATA _NULL_;
         FILE "&g_tsuScnLogFolder./00&i..log";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "&g_tsuScnLogFolder./00&i._003.log";
         PUT "hugo&i.";
      RUN;

      %*** Create test coverage files ***;
      DATA _NULL_;
         FILE "&g_tsuReportFolder./testDoc/testCoverage/00&i..tcg";
         PUT "hugo&i.";
      RUN;
      
      %*** Create test doc files ***;
      DATA _NULL_;
         FILE "&g_tsuReportFolder./testDoc/cas_00&i._004.html";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "&g_tsuReportFolder./testDoc/00&i._004_006.html";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "&g_tsuReportFolder./testDoc/00&i..lst";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "&g_tsuReportFolder./testDoc/00&i._003.lst";
         PUT "hugo&i.";
      RUN;
      
      %*** Create temp doc files ***;
      DATA _NULL_;
         FILE "&g_tsuReportFolder./tempDoc/_001_005_004_assertlibrary/test.sas7bdat";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "&g_tsuReportFolder./tempDoc/_001_009_001_assertlibrary/test1.sas7bdat";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "&g_tsuReportFolder./tempDoc/_002_002_001_assertreport/test.sas7bdat";
         PUT "hugo&i.";
      RUN;
      DATA _NULL_;
         FILE "&g_tsuReportFolder./tempDoc/_001_005_004_assertlibrary/test1.sas7bdat";
         PUT "hugo&i.";
      RUN;  
      DATA _NULL_;
         FILE "&g_tsuReportFolder./tempDoc/_003_002_001_assertreport/test.sas7bdat";
         PUT "hugo&i.";
      RUN;      
   %END;
%MEND _deleteScenarioFiles_crtTstFls;

%let g_tsuScnLogFolder=%sysfunc(pathname(work))/scn_logs;
%let g_tsuReportFolder=%sysfunc(pathname(work))/doc;

data work.tsu;
   set target.tsu;
run;

proc sql;
   update work.tsu set tsu_parameterValue = "&g_tsuScnLogFolder." where tsu_parameterName = "TSU_SCNLOGFOLDER";
   update work.tsu set tsu_parameterValue = "&g_tsuReportFolder." where tsu_parameterName = "TSU_REPORTFOLDER";
quit;

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
   /* Folder tempDoc */
   %assertEquals(i_actual=%_existDir(&g_tsuReportFolder./tempDoc/_001_005_004_assertlibrary),i_expected=0, i_desc=Test if folders tst/_001* exists%str(,) folder to delete _001_005_004_assertlibrary);
   %assertEquals(i_actual=%_existDir(&g_tsuReportFolder./tempDoc/_001_009_001_assertlibrary),i_expected=0, i_desc=Test if folders tst/_001* exists%str(,) folder to delete _001_009_001_assertlibrary);
   %assertEquals(i_actual=%_existDir(&g_tsuReportFolder./tempDoc/_002_002_001_assertreport), i_expected=1, i_desc=Test if folders tst/_001* exists%str(,) folder not to delete _002_002_001_assertreport);
   %assertEquals(i_actual=%_existDir(&g_tsuReportFolder./tempDoc/_003_002_001_assertreport), i_expected=1, i_desc=Test if folders tst/_001* exists%str(,) folder not to delete _003_002_001_assertreport);

   /* Folder scnLog */
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuScnLogFolder./001.log)),          i_expected=0, i_desc=Test if files log/_001* exists%str(,) file to delete 001.log);  
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuScnLogFolder./001_003.log)),      i_expected=0, i_desc=Test if files log/_001* exists%str(,) file to delete 001_003.log);
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuScnLogFolder./003.log)),          i_expected=1, i_desc=Test if files log/_001* exists%str(,) file not to delete 003.log);

   /* Folder testDoc */
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/001.lst)),          i_expected=0, i_desc=Test if file tst/001.lst exists%str(,) file to delete 001.lst);
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/001_003.lst)),      i_expected=0, i_desc=Test if file tst/001_*.lst exists%str(,) file to delete 001_003.lst);
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/002.lst)),          i_expected=1, i_desc=Test if file tst/002.lst exists%str(,) file not to delete 002.lst);
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/002_003.lst)),      i_expected=1, i_desc=Test if file tst/002_*.lst exists%str(,) file not to delete 002_003.lst);
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/001_004_006.html)), i_expected=0, i_desc=Test if files rep/001* exists%str(,) file to delete 001_004_006.html);  
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/002_004_006.html)), i_expected=1, i_desc=Test if files rep/002* exists%str(,) file not to delete 002_004_006.html);  
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/003_004_006.html)), i_expected=1, i_desc=Test if files rep/003* exists%str(,) file not to delete 003_004_006.html);      
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/cas_001_004.html)), i_expected=0, i_desc=Test if files rep/cas_001* exists%str(,) file to delete cas_001_004.html);  
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/cas_002_004.html)), i_expected=1, i_desc=Test if files rep/cas_002* exists%str(,) file not to delete cas_002_004.html);
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/cas_003_004.html)), i_expected=1, i_desc=Test if files rep/cas_003* exists%str(,) file not to delete cas_003_004.html);

   /* Folder testDoc/TestCoverage */
   %assertEquals(i_actual=%sysfunc(fileexist(&g_tsuReportFolder./testDoc/TestCoverage/001.tcg)),          i_expected=0, i_desc=Test if files log/_001* exists%str(,) file to delete 001.tcg);
%endTestcase(i_assertLog=0)

%endScenario();
/** \endcond */
