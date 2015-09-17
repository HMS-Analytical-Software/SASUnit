/**
\defgroup   SASUNIT_TEST
\file

\brief      Program for tests of _getpgmdesc with brief tag
\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme/.

*/ /** \cond */ 

%MACRO macro_without_brief_tag (i_desc);
   %put &i_desc.;
%MEND macro_without_brief_tag;
/** \endcond */
