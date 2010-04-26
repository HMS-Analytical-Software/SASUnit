/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      Anzahl Beobachtungen einer SAS-Datei zurückgeben. 

            Anzahl logische Beobachtungen (gelöschte nicht mitgerechnet)   
            einer SAS-Datei zurückgeben. Bei ungültiger Dateiangabe wird ein 
            Leerzeichen zurückgegeben.

            Anwendungsbeispiel: \%put \%nobs(sasdatei);

\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/example/saspgm/nobs.sas $

\param      data SAS-Datei, deren Beobachtungen gezählt werden
\return     Anzahl Beobachtungen in der SAS-Datei
*/ /** \cond */ 

/* Änderungshistorie
   07.02.2008 AM  Neuerstellung
*/ 

%MACRO nobs(
   data
);
%local dsid nobs;
%let nobs=;
%let dsid=%sysfunc(open(&data));
%if &dsid>0 %then %do;
   %let nobs=%sysfunc(attrn(&dsid,nlobs));
   %let dsid=%sysfunc(close(&dsid));
%end;
&nobs
%MEND nobs;
/** \endcond */
