/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      kopiert einen kompletten Verzeichnisbaum
               verwendet Windows XCOPY, daher nur unter Windows

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_from       Einstiegspunkt des zu kopierenden Verzeichnisbaums
   \param   i_to         Ziel des Kopiervorgangs
   \return  automatische Makrovariable siehe &sysrc ist 0, wenn alles OK
*/ /** \cond */ 

%macro _sasunit_copyDir(
   i_from
  ,i_to
);

%local xwait xsync xmin;
%let xwait=%sysfunc(getoption(xwait));
%let xsync=%sysfunc(getoption(xsync));
%let xmin =%sysfunc(getoption(xmin));

options noxwait xsync xmin;

/*-- XCOPY
     /E Verzeichnisse (auch leere) und Dateien rekursiv kopieren
     /I keine Nachfrage, ob Datei oder Verzeichnis erstellt werden soll
     /Y keine Nachfrage bei Überschreiben
  --*/

%sysexec 
   xcopy
      "&i_from"
      "&i_to"
      /E /I /Y
;
%put sysrc=&sysrc;

options &xwait &xsync &xmin;

%mend _sasunit_copyDir;
/** \endcond */
