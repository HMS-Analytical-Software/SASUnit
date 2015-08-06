/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      Source code to show program documentation features
            This is a second line of brief

            This is a more detailed description of the unit under test

\details    This is a second line of detailed description
            This is a third line of brief

\version    \$Revision: 315 $
\author     \$Author: klandwich $
\date       \$Date: 2014-02-28 10:25:18 +0100 (Fr, 28 Feb 2014) $
\sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
\sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/example/saspgm/nobs.sas $
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

\param      Parameters can be specified here

\return     this tag holds returns of the unit under test
\retval     Values that are passed back from the unit under test

\remark     You can add remarks to units under test.
            Remarks include <b>bold</b> and <em>emphasized</em> text as well as line breaks.
            No explicit \\n is necessary for line breaks, but can be used. 

\todo       Set a reminder for future implementations

\test       Set a reminder for new tests

\bug        This is used to keep track of bugs that shall be fixed

\deprecated Give an explanation why this program is no longer used

*/ /** \cond */ 
%MACRO DoNothingMacro(Parameter1,Parameter2);
   /*** Here macros does nothing ***/

   %*** This section again does nothing ***;

   *** This section does the same as the one above ***;

%MEND DoNothingMacro;
/** \endcond */
