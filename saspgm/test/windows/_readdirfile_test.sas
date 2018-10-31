/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _readdirfile.sas

   \version    \$Revision: 535 $
   \author     \$Author: klandwich $
   \date       \$Date: 2017-09-21 14:15:47 +0200 (Do, 21 Sep 2017) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_dir_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _readdirfile.sas)

/*-- 001 german windows mapped drive ----------------------------------------------*/
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=german windows mapped drive
             )
%_readdirfile (i_dirfile =&g_testdata./dir_german_drive.txt
              ,i_encoding=pcoem850
              ,o_out     =work.german_drive
              );
%endTestcall;

%assertColumns(i_expected=refdata.german_drive
              ,i_actual=work.german_drive
              ,i_desc=reading german output with mapped drive
              )
%endTestcase;

/*-- 002 german windows unc path ----------------------------------------------*/
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=german windows unc path
             )
%_readdirfile (i_dirfile =&g_testdata./dir_german_unc.txt
              ,i_encoding=pcoem850
              ,o_out     =work.german_unc
              );
%endTestcall;

%assertColumns(i_expected=refdata.german_unc
              ,i_actual=work.german_unc
              ,i_desc=reading german output with mapped drive
              )
%endTestcase;

/*-- 003 english windows mapped drive ----------------------------------------------*/
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=english windows mapped drive
             )
%_readdirfile (i_dirfile =&g_testdata./dir_english_drive.txt
              ,i_encoding=pcoem850
              ,o_out     =work.english_drive
              );
%endTestcall;

%assertColumns(i_expected=refdata.english_drive
              ,i_actual=work.english_drive
              ,i_desc=reading english output with mapped drive
              )
%endTestcase;

/*-- 004 english windows unc path ----------------------------------------------*/
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=english windows unc path
             )
%_readdirfile (i_dirfile =&g_testdata./dir_english_unc.txt
              ,i_encoding=pcoem850
              ,o_out     =work.english_unc
              );
%endTestcall;

%assertColumns(i_expected=refdata.english_unc
              ,i_actual=work.english_unc
              ,i_desc=reading english output with unc path
              )
%endTestcase;

/*-- 005 hungarian windows mapped drive ----------------------------------------------*/
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=hungarian windows mapped drive
             )
%_readdirfile (i_dirfile =&g_testdata./dir_hungarian_drive.txt
              ,i_encoding=pcoem850
              ,o_out     =work.hungarian_drive
              );
%endTestcall;

%assertColumns(i_expected=refdata.hungarian_drive
              ,i_actual=work.hungarian_drive
              ,i_desc=reading hungarian output with mapped drive
              )
%endTestcase;

/*-- 006 hungarian windows unc path ----------------------------------------------*/
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=hungarian windows unc path
             )
%_readdirfile (i_dirfile =&g_testdata./dir_hungarian_unc.txt
              ,i_encoding=pcoem850
              ,o_out     =work.hungarian_unc
              );
%endTestcall;

%assertColumns(i_expected=refdata.english_unc
              ,i_actual=work.hungarian_unc
              ,i_desc=reading hungarian output with unc path
              )
%endTestcase;

%endScenario();
/** \endcond */
