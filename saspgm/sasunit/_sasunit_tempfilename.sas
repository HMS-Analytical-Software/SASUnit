/** \file
   \ingroup    SASUNIT_UTIL

   \brief      Erzeugen eines einzigartigen Namens einer tempor�ren Datei in der 
               Form WORK.DATAxxx, wobei xxx eine von SAS vergebene fortlaufende
               Ganzzahl ist.

               Alle diese von einem aufrufenden Makro lokal erzeugten Dateien k�nnen am Ende des aufrufenden Makros mit
               \%delTempFiles (delTempFiles.sas) wieder gel�scht werden. 

               Wichtig: damit nur im aufrufenden Makro erzeugte tempor�re Dateien gel�scht werden, 
               muss vor dem ersten Aufruf von \%tempFileName die Makrovariable l_first_temp definiert werden:
               \%LOCAL l_first_temp;

   Aufruf: \%LOCAL macvar; \%tempFileName(&macvar);

   \version 1.0
   \author  Andreas Mangold
   \date    02.02.2006
   \param   r_tempFile     Makrovariable f�r R�ckgabe des Dateinamens
   \sa      delTempFiles.sas
*/ /** \cond */ 

%MACRO _sasunit_tempFileName(r_TempFile);

/* Datei leer anlegen */
DATA;STOP;RUN;

/* Dateinamen zur�ckgeben */
%LET &r_TempFile=&syslast;
%PUT Tempor�re Datei %nrstr(&)&r_tempFile ist &&&r_tempFile;

/* Datei wieder l�schen, nur Name ben�tigt */
PROC SQL NOPRINT; 
   DROP TABLE &&&r_TempFile;
QUIT;

/* merke die erste Nummer f�r die lokale Umgebung */
%IF %symexist (l_first_temp) %THEN %DO;
   %IF &l_first_temp = %THEN %LET l_first_temp = %substr(&syslast,10);
%END;

%MEND _sasunit_tempFileName;
/** \endcond */
