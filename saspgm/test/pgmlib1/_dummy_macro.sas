/**
   \defgroup   SASUNIT_TEST
   \file

   \brief      Empty example program for testing.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 

%MACRO _dummy_macro(i_desc);
   %put &i_desc.;
%MEND _dummy_macro;
/** \endcond */
