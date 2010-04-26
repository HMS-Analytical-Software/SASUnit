/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Gibt die Anzahl Datens�tze in der Eingabedatei zur�ck 

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_data       SAS-Dateiname 
   \return  R�ckgabe Anzahl Datens�tze oder 0, wenn Datei nicht gefunden wird
*/ /** \cond */ 

/* �nderungshistorie
   07.02.2008 AM  Logische statt physische Observations zur�ckgeben
*/ 

%MACRO _sasunit_nobs(
    i_data
);
%local dsid nobs;
%let nobs=0;
%let dsid=%sysfunc(open(&i_data));
%if &dsid>0 %then %do;
   %let nobs=%sysfunc(attrn(&dsid,nlobs));
   %let dsid=%sysfunc(close(&dsid));
%end;
&nobs
%MEND _sasunit_nobs;
/** \endcond */
