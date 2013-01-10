/**
   \file
   \ingroup    SASUNIT_TEST

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

%initTestcase(i_object=pgm1_1.sas, i_desc=call of program 1 in library 1)
%pgm1_1()
%initTestcase(i_object=pgm1_2.sas, i_desc=call of program 2 in library 1)
%pgm1_2()
%endTestcase;
/** \endcond */
