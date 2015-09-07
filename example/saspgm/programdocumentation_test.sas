/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests showing program documentation features


   \version    \$Revision: 315 $
   \author     \$Author: klandwich $
   \date       \$Date: 2014-02-28 10:25:18 +0100 (Fr, 28 Feb 2014) $

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_abspath.sas $
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

*/ /** \cond */

/*-- Creation of base datasets -----------------------------------------*/
%initTestcase(i_object=ProgramDocumentationDummy.sas, i_desc=Showing program documentation features)

%endTestCall()

%assertLog (i_errors=0, i_warnings=0)
%endTestCase()

/** \endcond */
