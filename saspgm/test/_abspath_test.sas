/** \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of _absPath.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _absPath.sas);

%initTestcase(i_object=_absPath.sas, i_desc=concatenation and conversion \/)
%let abspath=%_absPath(c:\temp,test/test);
%assertEquals(i_expected=c:/temp/test/test, i_actual=&abspath, i_desc=concatenation and conversion \/)

%initTestcase(i_object=_absPath.sas, i_desc=concatenation and partial conversion \/)
%let abspath=%_absPath(c:/temp,test\test);
%assertEquals(i_expected=c:/temp/test/test, i_actual=&abspath, i_desc=concatenation and partial conversion \/)

%initTestcase(i_object=_absPath.sas, i_desc=drive letter at second parameter)
%let abspath=%_absPath(c:\temp,d:\test);
%assertEquals(i_expected=d:/test, i_actual=&abspath, i_desc=drive letter at second parameter)

%initTestcase(i_object=_absPath.sas, i_desc=double slash at second parameter)
%let abspath=%_absPath(c:\temp,//test);
%assertEquals(i_expected=//test, i_actual=&abspath, i_desc=double slash at second parameter)

%initTestcase(i_object=_absPath.sas, i_desc=double backslash at second parameter)
%let abspath=%_absPath(c:\temp,\\test);
%assertEquals(i_expected=//test, i_actual=&abspath, i_desc=double backslash at second parameter)

%initTestcase(i_object=_absPath.sas, i_desc=no root path and absolute second parameter)
%let abspath=%_absPath(,d:/test);
%assertEquals(i_expected=d:/test, i_actual=&abspath, i_desc=no root path and absolute second parameter)

%initTestcase(i_object=_absPath.sas, i_desc=no root path and relative second parameter)
%let abspath=%_absPath(,test);
%assertEquals(i_expected=test, i_actual=&abspath, i_desc=no root path and relative second parameter)

%initTestcase(i_object=_absPath.sas, i_desc=no second parameter)
%let abspath=%_absPath(c:\temp,);
%assertEquals(i_expected=, i_actual=&abspath, i_desc=no second parameter)

%initTestcase(i_object=_absPath.sas, i_desc=second parameter with wildcards)
%let abspath=%_absPath(c:\temp,test\*.sas);
%let expected=c:/temp/test/;
%let expected=%str(&expected.*.sas);
%assertEquals(i_expected=&expected, i_actual=&abspath, i_desc=second parameter with wildcards)

%endScenario();
/** \endcond */