/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of _crossReference.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */

%initScenario (i_desc=Test of _crossReference.sas)

/* Create test files */
%MACRO _createTestFiles;
   %LOCAL l_work;
   
   %LET l_work = %SYSFUNC(pathname(work));
   
   %*** Create test data base ***;
   PROC SQL NOPRINT;
      CREATE TABLE work.tsu(COMPRESS=CHAR)(                                      
          tsu_sasunitroot  CHAR(1000)        /* root path to sasunit files */
         ,tsu_sasunit      CHAR(1000)
         ,tsu_sasunit_os   CHAR(1000)        /* os-specific sasunit macros */
         ,tsu_sasautos     CHAR(1000)
         %DO i=1 %TO 9;
            ,tsu_sasautos&i   CHAR(1000)     /* auto call paths */
         %END;
      );

      INSERT INTO work.tsu(tsu_sasunitroot,tsu_sasunit,tsu_sasunit_os,tsu_sasautos,tsu_sasautos1,tsu_sasautos2)
      VALUES ("&l_work", 'saspgm/sasunit/', "saspgm/sasunit/linux/", 'saspgm/sasunit/', 'saspgm/testfolder1/', 'saspgm/testfolder2/');
   QUIT;

   %*** Create folder structure for the test ***;  

   %_mkdir(&l_work./saspgm);
   %_mkdir(&l_work./saspgm/sasunit);
   %_mkdir(&l_work./saspgm/sasunit/linux);
   %_mkdir(&l_work./saspgm/testfolder1);
   %_mkdir(&l_work./saspgm/testfolder2);
 
   %*** Copy test macros to folders created in work ***;
   %_copyfile(i_file=%_abspath(&g_root.,saspgm/test/pgmlib1/testmakro1.sas)
             ,o_file=%_abspath(&l_work.,saspgm/sasunit/testmakro1.sas)
             );
   %_copyfile(i_file=%_abspath(&g_root.,saspgm/test/pgmlib1/testmakro2.sas)
             ,o_file=%_abspath(&l_work.,saspgm/sasunit/linux/testmakro2.sas)
             );
   %_copyfile(i_file=%_abspath(&g_root.,saspgm/test/pgmlib1/testmakro3.sas)
             ,o_file=%_abspath(&l_work.,saspgm/testfolder1/testmakro3.sas)
             );
   %_copyfile(i_file=%_abspath(&g_root.,saspgm/test/pgmlib1/testmakro4.sas)
             ,o_file=%_abspath(&l_work.,saspgm/testfolder1/testmakro4.sas)
             );
   
%MEND _createTestFiles;

/* create test files */
%_createTestFiles; 

/* test case 1 ------------------------------------ */
%initTestcase(i_object=_crossReference.sas, i_desc=Testing if the test setup was successful)
%endTestcall()
   %markTest()
      /* Files and folder test */
      %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/saspgm/sasunit/testmakro1.sas))       ,i_expected=1, i_desc=Test setup: file Testmakro1 copied successfully);
      %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/saspgm/sasunit/linux/testmakro2.sas)) ,i_expected=1, i_desc=Test setup: file Testmakro2 copied successfully);
      %assertEquals(i_actual=%sysfunc(fileexist(%sysfunc(pathname(work))/saspgm/testfolder1/testmakro3.sas))   ,i_expected=1, i_desc=Test setup: file Testmakro3 copied successfully);
      %assertEquals(i_actual=%_existDir(%sysfunc(pathname(work))/saspgm/testfolder2)                           ,i_expected=1, i_desc=Test setup: Create folder saspgm/testfolder2);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 2 ------------------------------------ */
%initTestcase(i_object=_crossReference.sas, i_desc=Test table listcalling with i_includeSASUnit = 1)
/*-- switch to example database --------------------*/
%_switch();
   %_dir(i_path=%sysfunc(pathname(work))/saspgm, i_recursive=1, o_out=work.cr_dir);
   data work.cr_dir;
      set work.cr_dir;
      exa_filename=filename;
   run;
   %_crossReference(i_includeSASUnit  =1
                   ,i_examinee        =work.cr_dir
                   ,o_listcalling     =work.listcalling
                   ,o_dependency      =work.dependency
                   ,o_macroList       =work.macrolist
                   );

   /*-- switch to real database -----------------------*/
%_switch();
%endTestcall();
   %markTest();
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=5, i_where=                                                  , i_desc=Number of calling relationships);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=1, i_where=%str(caller="testmakro1"  and called="testmakro2"), i_desc=Number of calling relationships);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=1, i_where=%str(caller="testmakro1"  and called="testmakro4"), i_desc=Valid call);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=1, i_where=%str(caller="testmakro2"  and called="testmakro3"), i_desc=Valid call);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=1, i_where=%str(caller="testmakro2"  and called="testmakro4"), i_desc=Valid call);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=1, i_where=%str(caller="testmakro3"  and called="testmakro4"), i_desc=Valid call);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=0, i_where=%str(caller="testmakro1"  and called="testmakro3"), i_desc=Call in comment won%str(%')t be referenced);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 3 ------------------------------------ */
%initTestcase(i_object=_crossReference.sas, i_desc=Test table dependency with i_includeSASUnit = 1)
/*-- switch to example database --------------------*/
%endTestcall();
   %markTest();
      %assertRecordCount(i_libref=work, i_memname=Dependency, i_operator=EQ, i_recordsExp=6, i_where=                             ,         i_desc=Number of expected rows);
      %assertRecordCount(i_libref=work, i_memname=Dependency, i_operator=EQ, i_recordsExp=3, i_where=%str(caller="testmakro1.sas"),         i_desc=Number of calling relationships for testmakro1);
      %assertRecordCount(i_libref=work, i_memname=Dependency, i_operator=EQ, i_recordsExp=2, i_where=%str(caller="testmakro2.sas"),         i_desc=Number of calling relationships for testmakro2);
      %assertRecordCount(i_libref=work, i_memname=Dependency, i_operator=EQ, i_recordsExp=1, i_where=%str(caller="testmakro3.sas"),         i_desc=Number of calling relationships for testmakro3);
      %assertRecordCount(i_libref=work, i_memname=Dependency, i_operator=EQ, i_recordsExp=0, i_where=%str(caller="testmakro4.sas"),         i_desc=Number of calling relationships for testmakro4);
      %assertRecordCount(i_libref=work, i_memname=Dependency, i_operator=EQ, i_recordsExp=3, i_where=%str(calledByCaller="testmakro4.sas"), i_desc=Number of caller macros for testmakro4);
      %assertRecordCount(i_libref=work, i_memname=Dependency, i_operator=EQ, i_recordsExp=0, i_where=%str(calledByCaller="testmakro1.sas"), i_desc=Number of caller macros for testmakro4);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 4 ------------------------------------ */
%initTestcase(i_object=_crossReference.sas, i_desc=Test table macrolist with i_includeSASUnit = 1)
/*-- switch to example database --------------------*/
%endTestcall();
   %markTest();
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=4, i_where=                       ,           i_desc=Number of expected rows);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(name="testmakro1"),           i_desc=Macro call of testmakro1 found);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(membername="testmakro1.sas"), i_desc=Macroname correctly idntified for testmakro1);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(name="testmakro2"),           i_desc=Macro call of testmakro2 found);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(membername="testmakro2.sas"), i_desc=Macroname correctly idntified for testmakro2);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(name="testmakro3"),           i_desc=Macro call of testmakro3 found);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(membername="testmakro3.sas"), i_desc=Macroname correctly idntified for testmakro3);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(name="testmakro4"),           i_desc=Macro call of testmakro4 found);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(membername="testmakro4.sas"), i_desc=Macroname correctly idntified for testmakro4);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 5 ------------------------------------ */
%initTestcase(i_object=_crossReference.sas, i_desc=Test table listcalling with i_includeSASUnit = 0);
/*-- switch to example database --------------------*/
%_switch();
   %let l_sasunit = &g_sasunit;
   %let g_sasunit = saspgm/sasunit;
   %_dir(i_path=%sysfunc(pathname(work))/saspgm, i_recursive=1, o_out=work.cr_dir);
   data work.cr_dir;
      set work.cr_dir;
      exa_filename=filename;
   run;
   %_crossReference(i_includeSASUnit  =0
                   ,i_examinee        =work.cr_dir
                   ,o_listcalling     =work.listcalling
                   ,o_dependency      =work.dependency
                   ,o_macroList       =work.macrolist
                   );
   /*-- switch to real database -----------------------*/
   %let g_sasunit = &l_sasunit;
%_switch();
%endTestcall();
   %markTest();
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=1, i_where=                                                 , i_desc=Number of calling relationships);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=0, i_where=%str(caller="testmakro1" and called="testmakro2"), i_desc=Invalid call);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=0, i_where=%str(caller="testmakro1" and called="testmakro4"), i_desc=Invalid call);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=0, i_where=%str(caller="testmakro2" and called="testmakro3"), i_desc=Invalid call);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=0, i_where=%str(caller="testmakro2" and called="testmakro4"), i_desc=Invalid call);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=1, i_where=%str(caller="testmakro3" and called="testmakro4"), i_desc=Valid call);
      %assertRecordCount(i_libref=work, i_memname=Listcalling, i_operator=EQ, i_recordsExp=0, i_where=%str(caller="testmakro1" and called="testmakro3"), i_desc=Call in comment won%str(%')t be referenced);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 6 ------------------------------------ */
%initTestcase(i_object=_crossReference.sas, i_desc=Test table dependency with i_includeSASUnit = 0)
%endTestcall();
   %markTest();
      %assertRecordCount(i_libref=work, i_memname=Dependency, i_operator=EQ, i_recordsExp=1, i_where=                                                                 , i_desc=Number of expected rows);
      %assertRecordCount(i_libref=work, i_memname=Dependency, i_operator=EQ, i_recordsExp=1, i_where=%str(caller="testmakro3.sas" and calledByCaller="testmakro4.sas")
                        ,i_desc=Expected dependency found - testmakro3 is called by testmakro3);

      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 7 ------------------------------------ */
%initTestcase(i_object=_crossReference.sas, i_desc=Test table macrolist with i_includeSASUnit = 0)
/*-- switch to example database --------------------*/
%endTestcall();
   %markTest();
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=2, i_where=                       ,           i_desc=Number of expected rows);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(name="testmakro3"),           i_desc=Macro call of testmakro3 found);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(membername="testmakro3.sas"), i_desc=Macroname correctly idntified for testmakro3);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(name="testmakro4"),           i_desc=Macro call of testmakro4 found);
      %assertRecordCount(i_libref=work, i_memname=macrolist, i_operator=EQ, i_recordsExp=1, i_where=%str(membername="testmakro4.sas"), i_desc=Macroname correctly idntified for testmakro4);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

proc datasets lib=work nolist;
   delete tsu cr_dir;
run;
quit;

%endScenario();
/** \endcond */
