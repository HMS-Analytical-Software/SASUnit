/**
   \defgroup   SASUNIT_TEST
   \file

   \details    Programm für die Test von _getpgmdesc
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 

%MACRO macro_without_brief_tag (i_desc);
   %put &i_desc.;
%MEND macro_without_brief_tag;
/** \endcond */
