/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests showing program documentation features.<br>
               This is a second line of brief, that adds more information.^n
               This is a line with many characters, it needs to have more than 255.<br>
               With this line I will cross the boundary of 255 characters in the description field.


   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

*/ /** \cond */

%initTestcase(i_object=ProgramDocumentationDummy.sas, i_desc=Showing program documentation features)

%endTestCall()

%assertLog (i_errors=0, i_warnings=0)
%endTestCase()

/** \endcond */