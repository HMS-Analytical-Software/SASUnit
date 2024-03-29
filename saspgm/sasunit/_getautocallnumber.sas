/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      look for a specific program in all of the autocall libraries and return the 
               number of the library (0..10) or . if not found.\n
               For autocall library numbering see initsasunit.sas.

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
			   
   \param   i_object   program file name without path (for instance countobs.sas)

   \return           number of autocall library 0..10 or . if program file cannot be found

*/ /** \cond */ 
%MACRO _getAutocallNumber (i_object
                          );

   %LOCAL i l_path;

   %*** check all autocall paths ***;
   %DO i=0 %TO 29;
      %IF ("%cmpres (&&g_sasautos&i)" ne "") %THEN %DO;
         %LET l_path = &&g_sasautos&i/&i_object;
         %IF %sysfunc(fileexist(&l_path)) %THEN %DO;
            %eval(&i+2)
            %RETURN;
         %END;
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