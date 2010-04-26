/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      lineare Regressionsanalyse - Beispiel für SASUnit

            Berechnen einer linearen Regression mit Intercept für die beiden 
            Eingabevariablen und 
            - schreiben der Eingabevariablen plus geschätzte Werte in die Ausgabedatei out
            - die Parameter stehen in der Ausgabedatei parms
            - der Report wird im Format RTF ausgegeben und enthält auch einen Plot

            Dieses Beispiel enthält keine Überprüfungen der Eingabeparamter
            
\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/example/saspgm/boxplot.sas $

\param      data    Eingabedatei
\param      x       Variable für x-Achse, muss numerisch sein
\param      y       Variable für y-Achse, muss numerisch sein
\param      out     Ausgabedatei, enthält Variblen &x, &y und &yhat
\param      yhat    Name der Variablen mit den geschätzten Werten für die Ausgabedatei
\param      parms   Ausgabedatei mit Parametern
\param      report  Report-Ausgabedatei (mit Endung .rtf)
*/ /** \cond */ 

/* Änderungshistorie
   30.06.2008 AM  Neuerstellung
*/ 

%MACRO regression(
   data   =
  ,x      =
  ,y      = 
  ,out    = 
  ,yhat   = 
  ,parms  =
  ,report =
);

%local dsid;

ods _all_ close;
ods rtf file="&report"; 

/*-- Regression durchführen --------------------------------------------------*/
goptions ftext=Swiss;
proc reg data=&data outest=&parms; 
   model &y = &x; 
   output out=&out(keep=&x &y &yhat) p=&yhat; 
   plot &y * &x; 
run; quit; 

ods rtf close; 

%MEND regression;

/*
data test; 
   xx=1; yy=1; output; 
   xx=2; yy=4; output; 
   xx=3; yy=9; output; 
run; 

options mprint; 
%regression(
    data   = test
   ,x      = xx
   ,y      = yy
   ,out    = aus
   ,yhat   = yschaetz
   ,parms  = parameter
   ,report = c:\temp\report.rtf
)
*/
/** \endcond */
