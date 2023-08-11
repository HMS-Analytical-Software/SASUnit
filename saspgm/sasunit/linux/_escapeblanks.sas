/**
   \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      escapes blanks with backslashes if runnign under linux or aix

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

   \param   i_string   string to escape blanks in

   \return           modified string
*/ /** \cond */ 

%MACRO _escapeblanks (i_string
                     );

   %IF "&i_string" EQ "" %THEN %RETURN;
   %LET i_string = %sysfunc(tranwrd(&i_string., %str( ),%str(\ )));
   &i_string.

%MEND _escapeblanks;
/** \endcond */
