/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of the tree building and the functionality for program libraries - 
               will always run because program pgm3_2.sas is being generated on the fly

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/tree1_test.sas 
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

/* change log
   07.01.2013 AM  made clear in scenario description that this scenario runs always
*/ 

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
/** \endcond */
