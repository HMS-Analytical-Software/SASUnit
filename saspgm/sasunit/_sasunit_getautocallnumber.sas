/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      sucht ein Programm im aktuellen Autocall-Pfad und gibt die Nummer des Pfads (0..9) zurück
               oder 10, wenn des Programm nicht gefunden wurde

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007

   \param   i_root   optional: Rootpfad
   \param   i_path   zu prüfender Pfad

   \return           gibt die Pfadnummer zurück
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
%LET g_sasautos=C:\Projekte\sasunit\saspgm\sasunit;
%LET g_sasautos1=c:\temp;

%put %_sasunit_getAutocallNumber(deldir.sas);
*/
