/**
   \file
   \ingroup    SASUNIT_TP_TEST

   \brief      Test of the tree building and the functionality for program libraries

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initTestcase(i_object=pgm01_1.sas, i_desc=call of program 1 in library 1)
%pgm01_1()
%endTestcase;
%initTestcase(i_object=pgm01_2.sas, i_desc=call of program 2 in library 1)
%pgm01_2()
%endTestcase;
%initTestcase(i_object=pgm02_1.sas, i_desc=call of program 1 in library 2)
%pgm02_1()
%endTestcase;
%initTestcase(i_object=pgm02_2.sas, i_desc=call of program 2 in library 2)
%pgm02_2()
%endTestcase;
%initTestcase(i_object=pgm03_1.sas, i_desc=call of program 1 in library 3)
%pgm03_1()
%endTestcase;
%initTestcase(i_object=pgm03_2.sas, i_desc=call of program 2 in library 3)
%pgm03_2()
%endTestcase;
%initTestcase(i_object=pgm04_1.sas, i_desc=call of program 1 in library 4)
%pgm04_1()
%endTestcase;
%initTestcase(i_object=pgm04_2.sas, i_desc=call of program 2 in library 4)
%pgm04_2()
%endTestcase;
%initTestcase(i_object=pgm05_1.sas, i_desc=call of program 1 in library 5)
%pgm05_1()
%endTestcase;
%initTestcase(i_object=pgm05_2.sas, i_desc=call of program 2 in library 5)
%pgm05_2()
%endTestcase;
%initTestcase(i_object=pgm06_1.sas, i_desc=call of program 1 in library 6)
%pgm06_1()
%endTestcase;
%initTestcase(i_object=pgm06_2.sas, i_desc=call of program 2 in library 6)
%pgm06_2()
%endTestcase;
%initTestcase(i_object=pgm07_1.sas, i_desc=call of program 1 in library 7)
%pgm07_1()
%endTestcase;
%initTestcase(i_object=pgm07_2.sas, i_desc=call of program 2 in library 7)
%pgm07_2()
%endTestcase;
%initTestcase(i_object=pgm08_1.sas, i_desc=call of program 1 in library 8)
%pgm08_1()
%endTestcase;
%initTestcase(i_object=pgm08_2.sas, i_desc=call of program 2 in library 8)
%pgm08_2()
%endTestcase;
%initTestcase(i_object=pgm09_1.sas, i_desc=call of program 1 in library 9)
%pgm09_1()
%endTestcase;
%initTestcase(i_object=pgm09_2.sas, i_desc=call of program 2 in library 9)
%pgm09_2()
%endTestcase;
%initTestcase(i_object=pgm10_1.sas, i_desc=call of program 1 in library 10)
%pgm10_1()
%endTestcase;
%initTestcase(i_object=pgm10_2.sas, i_desc=call of program 2 in library 10)
%pgm10_2()
%endTestcase;
%initTestcase(i_object=pgm11_1.sas, i_desc=call of program 1 in library 11)
%pgm11_1()
%endTestcase;
%initTestcase(i_object=pgm11_2.sas, i_desc=call of program 2 in library 11)
%pgm11_2()
%endTestcase;
%initTestcase(i_object=pgm12_1.sas, i_desc=call of program 1 in library 12)
%pgm12_1()
%endTestcase;
%initTestcase(i_object=pgm12_2.sas, i_desc=call of program 2 in library 12)
%pgm12_2()
%endTestcase;
%initTestcase(i_object=pgm13_1.sas, i_desc=call of program 1 in library 13)
%pgm13_1()
%endTestcase;
%initTestcase(i_object=pgm13_2.sas, i_desc=call of program 2 in library 13)
%pgm13_2()
%endTestcase;

data _null_;
   file "&g_work/pgm14_1.sas";
   put '%MACRO pgm14_1();';
   put '%PUT Aufruf von pgm14_1;';
   put '%MEND pgm14_1;';
run;

%initTestcase(i_object=&g_work/pgm14_1.sas, i_desc=call of program with absolute path)
%include "&g_work/pgm14_1.sas";
%pgm14_1()
%endTestcase;
/** \endcond */
