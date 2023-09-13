/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _insertAutoCallPath.sas

   \version    \$Revision: 659 $
   \author     \$Author: klandwich $
   \date       \$Date: 2019-04-25 16:01:34 +0200 (Do, 25 Apr 2019) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_createrepdata_test.sas $
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
*/ /** \cond */ 

%initScenario (i_desc=Test of _insertautocallpath.sas);

%macro testcase(i_object=_insertautocallpath.sas, i_desc=%str(Call with new Path as fileref));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local 
      l_savedAutoCallPath
      l_expectedAutoCallPath
   ;

   %let l_savedAutoCallPath = %sysfunc (getoption (SASAUTOS));
   %let l_expectedAutoCallPath = %substr (&l_savedAutoCallPath, 2, %length(&l_savedAutoCallPath.)-2);

   filename HUGO "%sysfunc(pathname(WORK))";

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_insertAutoCallPath(HUGO);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=0);
   %assertEquals  (i_expected = %quote((&l_expectedAutoCallPath. HUGO))
                  ,i_actual   = %sysfunc (getoption (SASAUTOS))
                  ,i_desc     = Path shoud be equal
                  );

   options SASAUTOS=&l_savedAutoCallPath.;

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_insertautocallpath.sas, i_desc=%str(Call with existing Path as fileref));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local 
      l_savedAutoCallPath
      l_expectedAutoCallPath
   ;

   %let l_savedAutoCallPath = %sysfunc (getoption (SASAUTOS));
   %let l_expectedAutoCallPath = %substr (&l_savedAutoCallPath, 2, %length(&l_savedAutoCallPath.)-2);
   
   filename Fritz "%sysfunc(pathname(WORK))";
   %_insertAutoCallPath(Fritz);

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_insertAutoCallPath(Fritz);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=0);
   %assertEquals  (i_expected = %str(%(&l_expectedAutoCallPath. Fritz%))
                  ,i_actual   = %sysfunc (getoption (SASAUTOS))
                  ,i_desc     = Path shoud be equal
                  );

   options SASAUTOS=&l_savedAutoCallPath.;

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_insertautocallpath.sas, i_desc=%str(Call with new Path));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local 
      l_savedAutoCallPath
      l_expectedAutoCallPath
   ;

   %let l_savedAutoCallPath = %sysfunc (getoption (SASAUTOS));
   %let l_expectedAutoCallPath = %substr (&l_savedAutoCallPath, 2, %length(&l_savedAutoCallPath.)-2);

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_insertAutoCallPath(%sysfunc(pathname(WORK)));

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=0);
   %assertEquals  (i_expected = %quote((&l_expectedAutoCallPath. "%sysfunc(pathname(WORK))"))
                  ,i_actual   = %sysfunc (getoption (SASAUTOS))
                  ,i_desc     = Path shoud be equal
                  );

   options SASAUTOS=&l_savedAutoCallPath.;

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_insertautocallpath.sas, i_desc=%str(Call with existing Path as path));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local 
      l_savedAutoCallPath
      l_expectedAutoCallPath
   ;

   %let l_savedAutoCallPath = %sysfunc (getoption (SASAUTOS));
   %let l_expectedAutoCallPath = %substr (&l_savedAutoCallPath, 2, %length(&l_savedAutoCallPath.)-2);
   
   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_insertAutoCallPath(%sysfunc(pathname(WORK)));

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=0);
   %assertEquals  (i_expected = %str(%(&l_expectedAutoCallPath. "%sysfunc(pathname(WORK))"%))
                  ,i_actual   = %sysfunc (getoption (SASAUTOS))
                  ,i_desc     = Path shoud be equal
                  );

   options SASAUTOS=&l_savedAutoCallPath.;

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_insertautocallpath.sas, i_desc=%str(Call with subset of existing Path as path));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local 
      l_savedAutoCallPath
      l_expectedAutoCallPath
   ;

   %let l_savedAutoCallPath = %sysfunc (getoption (SASAUTOS));
   %let l_expectedAutoCallPath = %substr (&l_savedAutoCallPath, 2, %length(&l_savedAutoCallPath.)-2);
   
   %*_makedir(%sysfunc(pathname(WORK))/testdir);
   %_insertAutoCallPath(%sysfunc(pathname(WORK))/testdir);
   
   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_insertAutoCallPath(%sysfunc(pathname(WORK)));

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=0);
   %assertEquals  (i_expected = %str(%(&l_expectedAutoCallPath. "%sysfunc(pathname(WORK))/testdir" "%sysfunc(pathname(WORK))"%))
                  ,i_actual   = %sysfunc (getoption (SASAUTOS))
                  ,i_desc     = Path shoud be equal
                  );

   options SASAUTOS=&l_savedAutoCallPath.;

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%endScenario();
/** \endcond */