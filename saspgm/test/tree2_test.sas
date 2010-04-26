/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of the tree building and the functionality for program libraries

   \version    \$Revision: 40 $
   \author     \$Author: warnat $
   \date       \$Date: 2008-08-20 16:04:44 +0200 (Mi, 20 Aug 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/saspgm/test/tree2_test.sas $

*/

/*DE
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test des Tree-Aufbaus und der Funktionalität für Programmbibliotheken

   \version    \$Revision: 40 $
   \author     \$Author: warnat $
   \date       \$Date: 2008-08-20 16:04:44 +0200 (Mi, 20 Aug 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/saspgm/test/tree2_test.sas $

*/ /** \cond */ 

%initTestcase(i_object=pgm1_1.sas, i_desc=Aufruf von Programm 1 in Bibliothek 1)
%pgm1_1()
%initTestcase(i_object=pgm1_2.sas, i_desc=Aufruf von Programm 2 in Bibliothek 1)
%pgm1_2()
%endTestcase;
/** \endcond */
