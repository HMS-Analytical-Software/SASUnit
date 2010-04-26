/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test des Tree-Aufbaus und der Funktionalität für Programmbibliotheken

   \version    \$Revision: 23 $
   \author     \$Author: mangold $
   \date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/saspgm/test/tree2_test.sas $

*/ /** \cond */ 

%initTestcase(i_object=pgm1_1.sas, i_desc=Aufruf von Programm 1 in Bibliothek 1)
%pgm1_1()
%initTestcase(i_object=pgm1_2.sas, i_desc=Aufruf von Programm 2 in Bibliothek 1)
%pgm1_2()
%endTestcase;
/** \endcond */
