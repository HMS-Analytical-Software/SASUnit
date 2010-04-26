/** \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests für _sasunit_absPath.sas

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
*/ /** \cond */ 

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=Verkettung und Umwandlung \/)
%let abspath=%_sasunit_abspath(c:\temp,test/test);
%assertEquals(i_expected=c:/temp/test/test, i_actual=&abspath, i_desc=Verkettung und Umwandlung \/)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=Verkettung und Umwandlung \/)
%let abspath=%_sasunit_abspath(c:/temp,test\test);
%assertEquals(i_expected=c:/temp/test/test, i_actual=&abspath, i_desc=Verkettung und teilweise Umwandlung \/)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=Laufwerksbuchstabe am zweiten Parameter)
%let abspath=%_sasunit_abspath(c:\temp,d:\test);
%assertEquals(i_expected=d:/test, i_actual=&abspath, i_desc=Laufwerksbuchstabe am zweiten Parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=Doppelslash am zweiten Parameter)
%let abspath=%_sasunit_abspath(c:\temp,//test);
%assertEquals(i_expected=//test, i_actual=&abspath, i_desc=Doppelslash am zweiten Parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=Doppelbackslash am zweiten Parameter)
%let abspath=%_sasunit_abspath(c:\temp,\\test);
%assertEquals(i_expected=//test, i_actual=&abspath, i_desc=Doppelbackslash am zweiten Parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=kein Root-Pfad und absoluter zweiter Parameter)
%let abspath=%_sasunit_abspath(,d:/test);
%assertEquals(i_expected=d:/test, i_actual=&abspath, i_desc=kein Root-Pfad und absoluter zweiter Parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=kein Root-Pfad und relativer zweiter Parameter)
%let abspath=%_sasunit_abspath(,test);
%assertEquals(i_expected=test, i_actual=&abspath, i_desc=kein Root-Pfad und relativer zweiter Parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=kein zweiter Parameter)
%let abspath=%_sasunit_abspath(c:\temp,);
%assertEquals(i_expected=, i_actual=&abspath, i_desc=kein zweiter Parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=zweiter Parameter mit Wildcards)
%let abspath=%_sasunit_abspath(c:\temp,test\*.sas);
%let expected=c:/temp/test/;
%let expected=%str(&expected.*.sas);
%assertEquals(i_expected=&expected, i_actual=&abspath, i_desc=zweiter Parameter mit Wildcards)

/** \endcond */ 
