/** \file
   \ingroup    SASUNIT_UTIL

   \brief      Ausführen eines Betriebssystemkommandos

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   cmd     Betriebssystemkommandos, notwendige Quotes eingefügt
   \return  setzt Fehlervariable &sysrc auf ungleich 0, wenn Fehler aufgetreten.

 */ /** \cond */ 

/* Änderungshistorie
   02.10.2008 NA  Anpassung an Linux
*/ 

%macro _sasunit_xcmd(i_cmd);
%if &sysscp. = WIN %then %do; 
	%local xwait xsync xmin;
	%let xwait=%sysfunc(getoption(xwait));
	%let xsync=%sysfunc(getoption(xsync));
	%let xmin =%sysfunc(getoption(xmin));

	options noxwait xsync xmin;

	%SYSEXEC &i_cmd;

	options &xwait &xsync &xmin;
%end;

%else %if &sysscp. = LINUX %then %do;
	%SYSEXEC &i_cmd;
%end;

%mend _sasunit_xcmd; 

/** \endcond */

