/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of the tree building and the functionality for program libraries - 
               will always run because program pgm3_2.sas is being generated on the fly

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/tree1_test.sas 
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */  
%initScenario (i_desc=Test of the tree building and the functionality for program libraries - 
               will always run because program pgm3_2.sas is being generated on the fly);

%initTestcase(i_object=pgm1_1.sas, i_desc=call of program 1 in library 1)
%pgm1_1()
%initTestcase(i_object=pgm1_2.sas, i_desc=call of program 2 in library 1)
%pgm1_2()
%initTestcase(i_object=pgm2_1.sas, i_desc=call of program 1 in library 2)
%pgm2_1()
%initTestcase(i_object=pgm2_2.sas, i_desc=call of program 2 in library 2)
%pgm2_2()
%initTestcase(i_object=saspgm/test/pgmlib3/pgm3_1.sas, i_desc=call of program with relative path)
%include "&g_root/saspgm/test/pgmlib3/pgm3_1.sas";
%pgm3_1()
%endTestcase()

data _null_;
   file "&g_work/pgm3_2.sas";
   put '%MACRO pgm3_2();';
   put '%PUT Aufruf von pgm3_2;';
   put '%MEND pgm3_2;';
run;

%initTestcase(i_object=&g_work/pgm3_2.sas, i_desc=call of program with absolute path)
%include "&g_work/pgm3_2.sas";
%pgm3_2()
%endTestcase;

%endScenario();
/** \endcond */