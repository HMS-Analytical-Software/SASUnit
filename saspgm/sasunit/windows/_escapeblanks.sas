/**
   \file
   \ingroup    SASUNIT_UTIL_OS_WIN

   \brief      escapes blanks with backslashes if runnign under linux or aix

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_string   string to escape blanks in

   \return           modified string
*/ /** \cond */ 

%MACRO _escapeblanks (i_string
                     );

   %IF "&i_string" EQ "" %THEN %RETURN;
   &i_string.

%MEND _escapeblanks;
/** \endcond */
