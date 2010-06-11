/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of the tree building and the functionality for program libraries

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/

/*DE
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test des Tree-Aufbaus und der Funktionalität für Programmbibliotheken

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

%initTestcase(i_object=pgm1_1.sas, i_desc=Aufruf von Programm 1 in Bibliothek 1)
%pgm1_1()
%initTestcase(i_object=pgm1_2.sas, i_desc=Aufruf von Programm 2 in Bibliothek 1)
%pgm1_2()
%endTestcase;
/** \endcond */
