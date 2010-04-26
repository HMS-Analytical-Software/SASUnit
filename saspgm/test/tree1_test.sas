/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of the tree building and the functionality for program libraries

   \version    \$Revision: 40 $
   \author     \$Author: warnat $
   \date       \$Date: 2008-08-20 16:04:44 +0200 (Mi, 20 Aug 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/test/tree1_test.sas $

*/

/*DE
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test des Tree-Aufbaus und der Funktionalität für Programmbibliotheken

   \version    \$Revision: 40 $
   \author     \$Author: warnat $
   \date       \$Date: 2008-08-20 16:04:44 +0200 (Mi, 20 Aug 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/test/tree1_test.sas $

*/ /** \cond */ 

%initTestcase(i_object=pgm1_1.sas, i_desc=Aufruf von Programm 1 in Bibliothek 1)
%pgm1_1()
%initTestcase(i_object=pgm1_2.sas, i_desc=Aufruf von Programm 2 in Bibliothek 1)
%pgm1_2()
%initTestcase(i_object=pgm2_1.sas, i_desc=Aufruf von Programm 1 in Bibliothek 2)
%pgm2_1()
%initTestcase(i_object=pgm2_2.sas, i_desc=Aufruf von Programm 2 in Bibliothek 2)
%pgm2_2()
%initTestcase(i_object=saspgm/test/pgmlib3/pgm3_1.sas, i_desc=Aufruf von Programm über relativen Pfad)
%include "&g_root/saspgm/test/pgmlib3/pgm3_1.sas";
%pgm3_1()
%endTestcase()

data _null_;
   file "&g_work/pgm3_2.sas";
   put '%MACRO pgm3_2();';
   put '%PUT Aufruf von pgm3_2;';
   put '%MEND pgm3_2;';
run;

%initTestcase(i_object=&g_work/pgm3_2.sas, i_desc=Aufruf von Programm über absoluten Pfad)
%include "&g_work/pgm3_2.sas";
%pgm3_2()
%endTestcase;
/** \endcond */
