/** \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      escapes blanks with backslashes if runnign under linux or aix

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
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
