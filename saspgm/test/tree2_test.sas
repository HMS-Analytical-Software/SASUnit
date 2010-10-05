/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of the tree building and the functionality for program libraries

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

%initTestcase(i_object=pgm1_1.sas, i_desc=call of program 1 in library 1)
%pgm1_1()
%initTestcase(i_object=pgm1_2.sas, i_desc=call of program 2 in library 1)
%pgm1_2()
%endTestcase;
/** \endcond */
