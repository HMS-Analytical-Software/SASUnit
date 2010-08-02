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
*/ /** \cond */ 

%MACRO _sasunit_getAutocallNumber (
    i_object
);

%LOCAL l_path;
%LET l_path = &g_sasautos/&i_object;
%IF %sysfunc(fileexist(&l_path)) %THEN %DO;
   0
   %RETURN;
%END;

%LOCAL i;
%DO i=1 %TO 9;
   %LET l_path = &&g_sasautos&i/&i_object;
   %IF %sysfunc(fileexist(&l_path)) %THEN %DO;
      &i
      %RETURN;
   %END;
%END;

.

%MEND _sasunit_getAutocallNumber;
/** \endcond */
/*
%LET g_sasautos=c:\projects\sasunit\saspgm\sasunit;
%LET g_sasautos1=c:\temp;

%put %_sasunit_getAutocallNumber(deldir.sas);
*/
