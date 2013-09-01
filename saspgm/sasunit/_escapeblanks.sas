/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      escapes blanks with backslashes if runnign under linux

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
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

   %if (&sysscp. = LINUX) %then %do;
      %let i_string = %qsysfunc(tranwrd(&i_string., %str( ),%str(\ )));
   %end;
   &i_string.

%MEND _escapeblanks;
/** \endcond */
