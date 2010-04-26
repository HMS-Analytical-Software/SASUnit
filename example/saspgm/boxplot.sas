/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      Boxplot für zwei Gruppen erstellen. 

            Chart mit folgenden Eigenschaften: 
            - zwei überlagerte Boxplots, einer pro Gruppe, die beiden Plots
              sollen leicht versetzt sein, um die Lesbarkeit zu gewährleisten
            - der Boxplot mit dem kleineren Wert von &group hat die Farbe grau 
              mit gestrichelter Medianlinie
            - der Boxplot mit dem größeren Wert von &group hat die Farbe schwarz
              mit durchgezogener Medianlinie
            - jede Box geht vom 25. bis zum 75. Perzentil
            - Whiskers werden bis zum größten bzw. kleinsten Wert gezeichnet
            - die Labels der Variablen &x und &y werden an die jeweiligen Achsen 
              geschrieben
            - für die Gruppe wird eine Legende ausgegeben
            - der Report wird im Format RTF ausgegeben
            
\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/example/saspgm/boxplot.sas $

\param      data    Eingabedatei
\param      x       Variable für x-Achse, muss numerisch und äquidistant sein
                    und mindestens zwei Ausprägungen haben, 
                    fehlende Werte sind nicht erlaubt
\param      y       Variable für y-Achse, muss numerisch sein
\param      group   Variable für Gruppierung, muss dichotom sein
                    fehlende Werte sind nicht erlaubt
\param      report  Ausgabedatei (mit Endung .rtf)
*/ /** \cond */ 

/* Änderungshistorie
   11.02.2008 AM  Fehlerkorrekturen
   07.02.2008 AM  Neuerstellung
*/ 

%MACRO boxplot(
   data   =
  ,x      =
  ,y      = 
  ,group  = 
  ,report =
);

%local dsid grouptype xvalues xvalues2;

/*-- prüfe Eingabedatei ------------------------------------------------------*/
%let dsid=%sysfunc(open(&data));
%if &dsid=0 %then %do; 
   %put ERROR: boxplot: Datei &data existiert nicht; 
   %return; 
%end; 
/*-- prüfe, ob x-Achsen-Variable angegeben ist -------------------------------*/
%if "&x"="" %then %do;
   %put ERROR: boxplot: X-Variable wurde nicht angegeben; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- prüfe, ob x-Achsen-Variable existiert -----------------------------------*/
%if %sysfunc(varnum(&dsid,&x))=0 %then %do;
   %put ERROR: boxplot: Variable &x existiert nicht in Datei &data ; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 

/*-- prüfe, ob x-Achsen-Variable numerisch ist -------------------------------*/
%if %sysfunc(vartype(&dsid,%sysfunc(varnum(&dsid,&x)))) NE N %then %do;
   %put ERROR: boxplot: Variable &x in Datei &data muss numerisch sein; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- ermittle die Ausprägungen der x-Achsen-Variable für die Achsen ----------*/
proc sql noprint;
   select distinct &x into :xvalues separated by '" "' from &data;
   select distinct &x into :xvalues2 separated by ' ' from &data;
quit;
/*-- prüfe, ob y-Achsen-Variable angegeben ist -------------------------------*/
%if "&y"="" %then %do;
   %put ERROR: boxplot: Y-Variable wurde nicht angegeben; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- prüfe, ob y-Achsen-Variable existiert -----------------------------------*/
%if %sysfunc(varnum(&dsid,&y))=0 %then %do;
   %put ERROR: boxplot: Variable &y existiert nicht in Datei &data ; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- prüfe, ob y-Achsen-Variable numerisch ist -------------------------------*/
%if %sysfunc(vartype(&dsid,%sysfunc(varnum(&dsid,&y)))) NE N %then %do;
   %put ERROR: boxplot: Variable &y in Datei &data muss numerisch sein; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- prüfe, ob Gruppierungsvariable angegeben wurde --------------------------*/
%if "&group"="" %then %do;
   %put ERROR: boxplot: Group-Variable wurde nicht angegeben; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- prüfe, ob Gruppierungsvariable existiert --------------------------------*/
%if %sysfunc(varnum(&dsid,&group))=0 %then %do;
   %put ERROR: boxplot: Variable &group existiert nicht in Datei &data ; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- Prüfe, ob Anzahl Gruppen=2, ermittle Variablentyp und niedrigere Gruppe -*/
%let grouptype=%sysfunc(vartype(&dsid,%sysfunc(varnum(&dsid,&group))));
%local count lower;
proc sql noprint;
   select count(distinct &group) into :count from &data;
   select min(&group) into :lower from &data;
quit; 
%if &lower=. %then %do; 
   %put ERROR: boxplot: Fehlende Werte in der Group-Variablen sind nicht zugelassen;
   %return; 
   proc sql noprint; drop table &d_1; quit;
%end; 
%if &count NE 2 %then %do;
   %put ERROR: boxplot: Variable &group muss genau zwei Ausprägungen haben; 
   %return; 
%end; 

%let dsid=%sysfunc(close(&dsid));

/*-- berechne den Abstand zwischen den X-Werten ------------------------------*/
%local d_1;
DATA; RUN; 
%let d_1=&syslast; 

proc sql noprint;   
   create table &d_1 as select distinct &x from &data;
quit;
 
data &d_1; 
   set &d_1; 
   &x = &x - lag(&x);
   if _n_>1 then output; 
run; 

%local xdiff1 xdiff2 xmin xmax misscount;
proc sql noprint; 
   select mean(&x), min(&x) into :xdiff1, :xdiff2 from &d_1;
   select min(&x), max(&x) into :xmin, :xmax from &data;
%let misscount=0;
   select count(*) into :misscount from &data where &x is missing;
quit;
%if &xdiff1=. %then %do;
   %put ERROR: boxplot: es müssen mindestens zwei X-Werte vorhanden sein;
   %return; 
   proc sql noprint; drop table &d_1; quit;
%end; 
%if &misscount>0 %then %do; 
   %put ERROR: boxplot: Fehlende Werte in der X-Variablen sind nicht zugelassen;
   %return; 
   proc sql noprint; drop table &d_1; quit;
%end; 

%let xmin=%sysevalf(&xmin-&xdiff1);
%let xmax=%sysevalf(&xmax+&xdiff1);

run; 
%if &xdiff1 ne &xdiff2 %then %do; 
   %put ERROR: boxplot: x-Achsen-Werte haben keine gleichförmigen Abstände;
   %return; 
   proc sql noprint; drop table &d_1; quit;
%end; 

/*-- richte einen Versatz zwischen den Plots der beiden Gruppen ein ----------*/
%local d_plot;
data;
   SET &data (KEEP=&x &y &group);
   IF &group = %if &grouptype=N %then &lower; %else "&lower"; THEN DO;
      &x = &x - 0.11*&xdiff1;
   END;
   ELSE DO;
      &x = &x + 0.11*&xdiff1;
   END;
RUN;
%let d_plot=&syslast;

/*-- erstelle Grafik ---------------------------------------------------------*/
GOPTIONS FTEXT="Arial" HTEXT=12pt DEVICE=actximg;
SYMBOL1 WIDTH = 3 BWIDTH = 3 COLOR = gray  LINE = 2 VALUE = none INTERPOL = BOXJT00 MODE = include;
SYMBOL2 WIDTH = 3 BWIDTH = 3 COLOR = black LINE = 1 VALUE = none INTERPOL = BOXJT00 MODE = include;
AXIS1 LABEL=(ANGLE=90) MINOR=none;
AXIS2 ORDER=(&xmin &xvalues2 &xmax) VALUE=(" " "&xvalues" " ") MINOR=none;
LEGEND1 FRAME;

ODS RTF FILE="&report";
PROC GPLOT DATA=&d_plot;
   PLOT &y * &x = &group / VAXIS=Axis1 HAXIS=Axis2 LEGEND=Legend1 NOFRAME;
RUN;
QUIT;
ODS RTF CLOSE;

proc sql noprint; 
   drop table &d_plot; 
   drop table &d_1; 
quit;

%MEND boxplot;
/** \endcond */
