/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertEquals.sas, has to fail!

   \version    \$Revision: 56 $
   \author     \$Author: mangold $
   \date       \$Date: 2009-07-16 15:15:52 +0200 (Do, 16 Jul 2009) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/test/assertequals_test.sas $
*/

/*DE
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests für assertEquals.sas, muss rot sein

   \version    \$Revision: 56 $
   \author     \$Author: mangold $
   \date       \$Date: 2009-07-16 15:15:52 +0200 (Do, 16 Jul 2009) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/test/assertequals_test.sas $
*/ /** \cond */ 

/* Änderungshistorie
   10.10.2008 AM  Bug fixing
   27.06.2008 AM Neuerstellung
*/ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Gleiche Werte, kein Fuzz))
%endTestcall()
%assertEquals(i_actual=20, i_expected=20, i_desc=die Beschreibung 1)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 1)
%assertDBValue(tst,exp,20)
%assertDBValue(tst,act,20)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Gleiche Werte, mit Fuzz))
%endTestcall()
%assertEquals(i_actual=20, i_expected=20, i_desc=die Beschreibung 2, i_fuzz=1)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 2)
%assertDBValue(tst,exp,20(+-1))
%assertDBValue(tst,act,20)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Unterschiedliche Werte, kein Fuzz, muss rot sein))
%endTestcall()
%assertEquals(i_actual=19, i_expected=20, i_desc=die Beschreibung 3)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 3)
%assertDBValue(tst,exp,20)
%assertDBValue(tst,act,19)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Unterschiedliche Werte, mit Fuzz, im Bereich))
%endTestcall()
%assertEquals(i_actual=19, i_expected=20, i_desc=die Beschreibung 4, i_fuzz=2)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 4)
%assertDBValue(tst,exp,20(+-2))
%assertDBValue(tst,act,19)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Unterschiedliche Werte, mit Fuzz, am Rand des Bereichs))
%endTestcall()
%assertEquals(i_actual=18, i_expected=20, i_desc=die Beschreibung 5, i_fuzz=2)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 5)
%assertDBValue(tst,exp,20(+-2))
%assertDBValue(tst,act,18)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Unterschiedliche Werte, mit Fuzz, außerhalb des Bereichs, muss rot sein))
%endTestcall()
%assertEquals(i_actual=17, i_expected=20, i_desc=die Beschreibung 6, i_fuzz=2)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 6)
%assertDBValue(tst,exp,20(+-2))
%assertDBValue(tst,act,17)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Unterschiedliche Werte, mit Fuzz, innerhalb des Bereichs, floating points))
%endTestcall()
%assertEquals(i_actual=17.86532, i_expected=20, i_desc=die Beschreibung 7, i_fuzz=10)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 7)
%assertDBValue(tst,exp,20(+-10))
%assertDBValue(tst,act,17.86532)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Unterschiedliche Werte, mit Fuzz, außerhalb des Bereichs, floating points, muss rot sein))
%endTestcall()
%assertEquals(i_actual=117.86532, i_expected=20, i_desc=die Beschreibung 8, i_fuzz=10)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 8)
%assertDBValue(tst,exp,20(+-10))
%assertDBValue(tst,act,117.86532)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Unterschiedliche Werte, mit Fuzz, innerhalb des Bereichs, floating points, gedreht))
%endTestcall()
%assertEquals(i_actual=20, i_expected=17.86532, i_desc=die Beschreibung 8, i_fuzz=10)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 8)
%assertDBValue(tst,exp,17.86532(+-10))
%assertDBValue(tst,act,20)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Unterschiedliche Werte, mit Fuzz, außerhalb des Bereichs, floating points, gedreht, muss rot sein))
%endTestcall()
%assertEquals(i_actual=20, i_expected=117.86532, i_desc=die Beschreibung 8, i_fuzz=10)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 8)
%assertDBValue(tst,exp,117.86532(+-10))
%assertDBValue(tst,act,20)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(Gleiche Werte, alphanumerisch))
%endTestcall()
%assertEquals(i_actual=AAA, i_expected=AAA, i_desc=die Beschreibung 9)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 9)
%assertDBValue(tst,exp,AAA)
%assertDBValue(tst,act,AAA)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(unterschiedliche Werte, alphanumerisch, muss rot sein))
%endTestcall()
%assertEquals(i_actual=BBB, i_expected=AAA, i_desc=die Beschreibung 10)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 10)
%assertDBValue(tst,exp,AAA)
%assertDBValue(tst,act,BBB)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(gleiche Werte, alphanumerisch, mit i_fuzz))
%endTestcall()
%assertEquals(i_actual=AAA, i_expected=AAA, i_desc=die Beschreibung 11, i_fuzz=1)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,die Beschreibung 11)
%assertDBValue(tst,exp,AAA)
%assertDBValue(tst,act,AAA)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)
