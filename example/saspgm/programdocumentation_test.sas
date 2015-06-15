/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests showing program documentation features


   \version    \$Revision: 315 $
   \author     \$Author: klandwich $
   \date       \$Date: 2014-02-28 10:25:18 +0100 (Fr, 28 Feb 2014) $
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/example/saspgm/database_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */

/*-- Creation of base datasets -----------------------------------------*/
%initTestcase(i_object=ProgramDocumentationDummy.sas, i_desc=Showing program documentation features)

%endTestCall()

%assertLog (i_errors=0, i_warnings=0)
%endTestCase()

/** \endcond */
