/**
\defgroup   SASUNIT_TEST
\file

\brief      Empty example program for testing.sas

\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

/* change log
   19.03.2013 KL added parameter and %put statement;
   13.12.2012 KL Neuerstellung
*/ 

%MACRO _dummy_macro(i_desc);
   %put &i_desc.;
%MEND _dummy_macro;
/** \endcond */
