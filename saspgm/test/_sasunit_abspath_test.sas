/** \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for _sasunit_absPath.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=concatenation and conversion \/)
%let abspath=%_sasunit_abspath(c:\temp,test/test);
%assertEquals(i_expected=c:/temp/test/test, i_actual=&abspath, i_desc=concatenation and conversion \/)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=concatenation and partial conversion \/)
%let abspath=%_sasunit_abspath(c:/temp,test\test);
%assertEquals(i_expected=c:/temp/test/test, i_actual=&abspath, i_desc=concatenation and partial conversion \/)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=drive letter at second parameter)
%let abspath=%_sasunit_abspath(c:\temp,d:\test);
%assertEquals(i_expected=d:/test, i_actual=&abspath, i_desc=drive letter at second parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=double slash at second parameter)
%let abspath=%_sasunit_abspath(c:\temp,//test);
%assertEquals(i_expected=//test, i_actual=&abspath, i_desc=double slash at second parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=double backslash at second parameter)
%let abspath=%_sasunit_abspath(c:\temp,\\test);
%assertEquals(i_expected=//test, i_actual=&abspath, i_desc=double backslash at second parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=no root path and absolute second parameter)
%let abspath=%_sasunit_abspath(,d:/test);
%assertEquals(i_expected=d:/test, i_actual=&abspath, i_desc=no root path and absolute second parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=no root path and relative second parameter)
%let abspath=%_sasunit_abspath(,test);
%assertEquals(i_expected=test, i_actual=&abspath, i_desc=no root path and relative second parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=no second parameter)
%let abspath=%_sasunit_abspath(c:\temp,);
%assertEquals(i_expected=, i_actual=&abspath, i_desc=no second parameter)

%initTestcase(i_object=_sasunit_abspath.sas, i_desc=second parameter with wildcards)
%let abspath=%_sasunit_abspath(c:\temp,test\*.sas);
%let expected=c:/temp/test/;
%let expected=%str(&expected.*.sas);
%assertEquals(i_expected=&expected, i_actual=&abspath, i_desc=second parameter with wildcards)

/** \endcond */ 
