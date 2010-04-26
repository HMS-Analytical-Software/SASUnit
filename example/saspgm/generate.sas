/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      Datei nach BY-Gruppen in einzelne SAS-Dateien 
            aufteilen

            By-Werte und Anzahl Beobachtungen werden in das Label jeder 
            Ausgabedatei geschrieben.

            Beispiel für die Anwendung von assertLibrary, siehe generate_test.sas.

\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/example/saspgm/generate.sas $

\param      data   Eingabedatei
\param      by     by-Variable(n) für die Teilung der Eingabedatei in Ausgabedateien
\param      out    Prefix für Ausgabedateien (Nummerierung wird angehängt)
*/ /** \cond */ 

/* Änderungshistorie
   05.02.2008 AM Neuerstellung
*/ 

%MACRO generate(
   data   =
  ,by     =
  ,out    =
);

/*-- lokale Dateien und Variablen erzeugen -----------------------------------*/
%local d_temp1 d_temp2;
data; run; %let d_temp1=&syslast;
data; run; %let d_temp2=&syslast;
%local i count bycount;

/*-- Eingabedatei sortieren und dabei Parameter prüfen -----------------------*/
proc sort data=&data out=&d_temp1;
   by &by;
run;
%if &syserr %then %do;
   %put ERROR: Macro Generate: falsche Angabe für data= oder by=;
   %return;
%end;

/*-- einzelne BY-Gruppen in Datei ermitteln und zählen -----------------------*/
proc means noprint data=&d_temp1(keep=&by);
   by &by;
   output out=&d_temp2;
run;

data _null_;
   set &d_temp2 nobs=count;
   call symput ("count", compress(put(count,8.)));
   stop;
run;
%do i=1 %to &count;
   %local label&i;
%end;

/*-- Dataset Label pro BY-Gruppe erzeugen ------------------------------------*/
data _null_;
   set &d_temp2 end=eof;
   array t(1) $ 200 _temporary_;
   t(1) = 'Datei für';
%let i=1;
%do %while(%scan(&by,&i) ne %str());
   %if &i>1 %then %do;
   t(1) = trim(t(1)) !! ',';
   %end;
   t(1) = trim(t(1)) !! " %scan(&by,&i)=" !! trim(left(vvalue(%scan(&by,&i))));
   %let i = %eval(&i+1);
%end;
%let bycount=%eval(&i-1);
   t(1) = trim(t(1)) !! ' (' !! compress(put(_freq_,8.)) !! ' Beobachtungen)';
   call symput ('label' !! compress(put(_n_,8.)), trim(t(1)));
run;

/*-- Ausgabedateien erzeugen -------------------------------------------------*/
data %do i=1 %to &count; &out&i (label="&&label&i") %end; ;
   set &d_temp1;
   by &by;
   array t(1) _temporary_;
   if first.%scan(&by,&bycount) then t(1)+1;
   select(t(1));
%do i=1 %to &count;
      when(&i) output &out&i;
%end;
   end;
run;

proc datasets lib=work nolist;
   delete %scan(&d_temp1,2,.) %scan(&d_temp2,2,.);
quit;
%MEND generate;
/** \endcond */
