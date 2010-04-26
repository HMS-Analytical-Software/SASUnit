/** \file
   \ingroup    SASUNIT_UTIL

   \brief      Erzeugt ein Verzeichnis, falls es noch nicht existiert. 
               Das übergeordnete Verzeichnis muss bereits existieren. 

               \%mkdir(dir=verzeichnis)

               setzt Fehlervariable &sysrc auf ungleich 0, wenn Fehler aufgetreten.

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   dir     kompletter Pfad des zu erstellenden Verzeichnis. 

*/ /** \cond */

/* Änderungshistorie
   05.09.2008 NA  Anpassung an Linux
*/ 

%macro _sasunit_mkdir(dir);


%if &sysscp. = WIN %then %do; 
	%local xwait xsync xmin;
	%let xwait=%sysfunc(getoption(xwait));
	%let xsync=%sysfunc(getoption(xsync));
	%let xmin =%sysfunc(getoption(xmin));

	options noxwait xsync xmin;

	%SYSEXEC(md "&dir");

	options &xwait &xsync &xmin;
%end;
%else %if &sysscp. = LINUX %then %do;
	%SYSEXEC(mkdir &dir.);
%end;

%mend _sasunit_mkdir; 

/** \endcond */

