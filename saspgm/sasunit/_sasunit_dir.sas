/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Gibt alle Dateinamen eines Verzeichnisses, eines Verzeichnisbaums
               oder einer Dateigruppe zurück

               Ergebnisse werden in einer SAS-Datei mit den Spalten
               filename (absoluter Pfad zur Datei, Backslashes in Slashes umgewandelt) und 
               changed (Änderungsdatum als datetime) zurückgegeben. 

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_path       Verzeichnis oder Dateiname oder Dateigruppe mit Wildcards
   \param   i_recursive  1 .. rekursive Suche auch in Unterverzeichnissen, 
                         Voreinstellung ist 0
   \param   o_outdir     Ausgabedatei, voreinstellung ist work.dir. Die datei enthält
                         eine Spalte namens filename und eine namens changed 
*/ /** \cond */

/* Änderungshistorie
   10.02.2008 AM  Dokumentation verbessert
   15.12.2007 AM  Abfrage nach sysrc entfernt, weil sysrc>0, wenn keine Datei gefunden;
                  Dateinamen mit slashes statt backslashes
*/ 

%MACRO _sasunit_dir(
    i_path=
   ,i_recursive=0
   ,o_out=dir
);
%local dirindicator filepos encoding;
%let dirindicator=Verzeichnis von;
%let filepos=37;
%let encoding=pcoem850;
%let i_path = %sysfunc(translate(&i_path,\,/));

proc sql noprint;
   create table &o_out (filename char(255));
quit;
%IF &syserr NE 0 %THEN %GOTO errexit;

%local xwait xsync xmin;
%let xwait=%sysfunc(getoption(xwait));
%let xsync=%sysfunc(getoption(xsync));
%let xmin =%sysfunc(getoption(xmin));

options noxwait xsync xmin;

%local dirfile;
%let dirfile=%sysfunc(pathname(work))\___dir.txt;
filename _dirfile "&dirfile" encoding=&encoding;
%local s;
%IF &i_recursive %then %let s=/S;
%SYSEXEC(dir &s /a-d "&i_path" > "&dirfile");

options &xwait &xsync &xmin;

data &o_out (keep=filename changed);
   length dir filename $255;
   retain dir;
   infile _dirfile truncover;
   input line $char255. @;
   if index (line, "&dirindicator") then do;
      dir = substr(line, index (line, "&dirindicator")+length("&dirindicator")+1);
   end;
   if substr(line,1,1) ne ' ' then do;
      input @1
         d ddmmyy10. +2
         t time5.
      ;
      changed = dhms (d, hour(t), minute(t), 0);
      format changed datetime20.;
      filename = translate(trim(dir) !! '/' !! substr(line,&filepos),'/','\');
      output;
   end;
run;

%local rc;
%let rc=%sysfunc(fdelete(_dirfile));

%errexit:
filename _dirfile;
%MEND _sasunit_dir;
/** \endcond */
