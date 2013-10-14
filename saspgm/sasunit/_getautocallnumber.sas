/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      look for a specific program in all of the autocall libraries and return the 
               number of the library (0..9) or 10 if not found.\n
               For autocall library numbering see initsasunit.sas.

   \param   i_object   program file name without path (for instance countobs.sas)

   \return           number of autocall library 0..9 or 10 if program file cannot be found

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%MACRO _getAutocallNumber (i_object
                          );

   %LOCAL i l_path;

   %*** check all autocall paths ***;
   %DO i=0 %TO 9;
      %LET l_path = &&g_sasautos&i/&i_object;
      %IF %sysfunc(fileexist(&l_path)) %THEN %DO;
         %eval(&i+2)
         %RETURN;
      %END;
   %END;

   %*** check for SASUnit program path ***;
   %LET l_path = &g_sasunit/&i_object;
   %IF %sysfunc(fileexist(&l_path)) %THEN %DO;
      0
      %RETURN;
   %END;

   %*** check for SASUnit os-specific program path ***;
   %LET l_path = &g_sasunit_os/&i_object;
   %IF %sysfunc(fileexist(&l_path)) %THEN %DO;
      1
      %RETURN;
   %END;
.

%MEND _getAutocallNumber;
/** \endcond */
/*
%LET g_sasautos=c:\projects\sasunit\saspgm\sasunit;
%LET g_sasautos1=c:\temp;

%put %_getAutocallNumber(deldir.sas);
*/
