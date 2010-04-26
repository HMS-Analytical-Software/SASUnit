/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      Variablen einer SAS-Datei zurückgeben

            Anwendungsbeispiel: \%put \%getvars(sasdatei);

\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/example/saspgm/getvars.sas $

\param      data SAS-Datei, deren Variablen zurückgegeben werden sollen
\param      dlm  Trennzeichen, Voreinstellung ist ein Leerzeichen
\return     Liste der Variablen in der Eingabedatei, getrennt durch das angegebene Trennzeichen
*/ /** \cond */ 

/* Änderungshistorie
   06.02.2008 AM  Neuerstellung
*/ 

%MACRO getvars(
   data
  ,dlm=
);
%local varlist dsid i;
%if "&dlm"="" %then %let dlm=%str( );
%let dsid = %sysfunc(open(&data));
%if &dsid %then %do ;
   %do i=1 %to %sysfunc(attrn(&dsid,NVARS));
      %if &i=1 %then 
         %let varlist = %sysfunc(varname(&dsid,&i));
      %else         
         %let varlist = &varlist.&dlm.%sysfunc(varname(&dsid,&i));
   %end;
   %let dsid = %sysfunc(close(&dsid));
%end;
&varlist
%MEND getvars;
/** \endcond */
