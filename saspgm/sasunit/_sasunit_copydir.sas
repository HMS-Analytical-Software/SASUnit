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

/* Änderungshistorie
   02.10.2008 NA  Anpassung an Linux
*/ 

%macro _sasunit_copyDir(
   i_from
  ,i_to
);

%if &sysscp. = WIN %then %do; 

   /* save and modify os command options */
   %local xwait xsync xmin;
   %let xwait=%sysfunc(getoption(xwait));
   %let xsync=%sysfunc(getoption(xsync));
   %let xmin =%sysfunc(getoption(xmin));
   options noxwait xsync xmin;

   %let i_from = %qsysfunc(translate(&i_from,\,/));
   %let i_to   = %qsysfunc(translate(&i_to  ,\,/));

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
%end;

%else %if &sysscp. = LINUX %then %do;
   %SYSEXEC(cp -R &i_from. &i_to.);
%end;

%mend _sasunit_copyDir;
/** \endcond */
