/*******

\defgroup   SASUNIT_TEST
\file

\brief      Empty example program without SAS Doc tags for testing.sas

\version    \$Revision: 314 $
\author     \$Author: klandwich $
\date       \$Date: 2014-02-15 10:57:09 +0100 (Sa, 15 Feb 2014) $
\sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/pgmlib1/_dummy_macro.sas $
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%MACRO _dummy_ohne_pgmdoc(i_desc);
   %put &i_desc.;
%MEND _dummy_ohne_pgmdoc;
/** \endcond */
