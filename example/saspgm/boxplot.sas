/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      Create boxplot for two groups 

            Specification for chart:  
            - two overlayed boxplots, one per group, the two plots shall be 
              slightly offset for readability. 
            - boxplot for the smaller value of &group has gray color with dashed median line
            - boxplot for the greater value of &group has black color with continuous median line
            - lower border of boxes are at 25th percentile, higher border at 75th percentile
            - whiskers shall be drawn from maximum and minimum value
            - labels for variables &x und &y shall be written to the axes
            - there shall be a legend for the group variable
            - report format ist PDF
            
\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

\param      data    input data sets
\param      x       variable for x axis, must be numeric and equidistant und must have at least two values, 
                    missing values are not allowed
\param      y       variable for y axis, must be numeric
\param      group   variable for grouping, must be dichotomous,
                    missing values are not allowed
\param      report  output report file (file name extension must be pdf)
*/ /** \cond */ 

/* History
   05.10.2010 AM  Changed output format to pdf in order to be able to run on linux
*/ 

%MACRO boxplot(
   data   =
  ,x      =
  ,y      = 
  ,group  = 
  ,report =
);

%local dsid grouptype xvalues xvalues2;

/*-- check input data set ----------------------------------------------------*/
%let dsid=%sysfunc(open(&data));
%if &dsid=0 %then %do; 
   %put ERROR: boxplot: Data set &data does not exist; 
   %return; 
%end; 
/*-- check whether x variable has been specified -----------------------------*/
%if "&x"="" %then %do;
   %put ERROR: boxplot: X variable not specified; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- check for existence of x variable ---------------------------------------*/
%if %sysfunc(varnum(&dsid,&x))=0 %then %do;
   %put ERROR: boxplot: Variable &x does not exist in data set &data ; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 

/*-- check whether x variable is numeric -------------------------------------*/
%if %sysfunc(vartype(&dsid,%sysfunc(varnum(&dsid,&x)))) NE N %then %do;
   %put ERROR: boxplot: Variable &x in data set &data must be numeric; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- determine values of x variable for axis ---------------------------------*/
proc sql noprint;
   select distinct &x into :xvalues separated by '" "' from &data;
   select distinct &x into :xvalues2 separated by ' ' from &data;
quit;
/*-- check whether y variable has been specified -----------------------------*/
%if "&y"="" %then %do;
   %put ERROR: boxplot: Y variable not specified; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- check for existence of y variable ---------------------------------------*/
%if %sysfunc(varnum(&dsid,&y))=0 %then %do;
   %put ERROR: boxplot: Variable &y does not exist in data set &data ; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- check wheter y variable ist numeric -------------------------------------*/
%if %sysfunc(vartype(&dsid,%sysfunc(varnum(&dsid,&y)))) NE N %then %do;
   %put ERROR: boxplot: Variable &y in data set &data must be numeric; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- check whether group variable has been specified -------------------------*/
%if "&group"="" %then %do;
   %put ERROR: boxplot: Group variable must be specified; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- check for existence of group variable -----------------------------------*/
%if %sysfunc(varnum(&dsid,&group))=0 %then %do;
   %put ERROR: boxplot: Variable &group does not exist in data set &data ; 
   %let dsid=%sysfunc(close(&dsid));
   %return; 
%end; 
/*-- check for number of groups and determine variable type and group sequence -*/
%let grouptype=%sysfunc(vartype(&dsid,%sysfunc(varnum(&dsid,&group))));
%local count lower;
proc sql noprint;
   select count(distinct &group) into :count from &data;
   select min(&group) into :lower from &data;
quit; 
%if &lower=. %then %do; 
   %put ERROR: boxplot: Missing values in group variable are not allowed; 
   %return; 
   %*** This is code not covered by any testcase and left intetionally here to ***;
   %*** demonstrate the functionality of the test coverage                     ***;
   proc sql noprint; drop table &d_1; quit;
%end; 
%if &count NE 2 %then %do;
   %put ERROR: boxplot: Variable &group must have exactly two values; 
   %return; 
%end; 

%let dsid=%sysfunc(close(&dsid));

/*-- calculate distance between the x values ---------------------------------*/
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
   %put ERROR: boxplot: x variable must have at least two values;
   proc sql noprint; drop table &d_1; quit;
   %return; 
%end; 
%if &misscount>0 %then %do; 
   %put ERROR: boxplot: Missing values in x variable are not allowed;
   proc sql noprint; drop table &d_1; quit;
   %return; 
%end; 

%let xmin=%sysevalf(&xmin-&xdiff1);
%let xmax=%sysevalf(&xmax+&xdiff1);

run; 
%if &xdiff1 ne &xdiff2 %then %do; 
   %put ERROR: boxplot: Values of x variable are not equidistant;
   proc sql noprint; drop table &d_1; quit;
   %return; 
%end; 

/*-- calculate offset between the plots of the two groups --------------------*/
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

/*-- create chart ------------------------------------------------------------*/
GOPTIONS FTEXT="Helvetica" HTEXT=12pt hsize=16cm vsize=16cm;
SYMBOL1 WIDTH = 3 BWIDTH = 3 COLOR = gray  LINE = 2 VALUE = none INTERPOL = BOXJT00 MODE = include;
SYMBOL2 WIDTH = 3 BWIDTH = 3 COLOR = black LINE = 1 VALUE = none INTERPOL = BOXJT00 MODE = include;
AXIS1 LABEL=(ANGLE=90) MINOR=none;
AXIS2 ORDER=(&xmin &xvalues2 &xmax) VALUE=(" " "&xvalues" " ") MINOR=none;
LEGEND1 FRAME;

ODS PDF FILE="&report";
ODS LISTING CLOSE;
PROC GPLOT DATA=&d_plot;
   PLOT &y * &x = &group / VAXIS=Axis1 HAXIS=Axis2 LEGEND=Legend1 NOFRAME;
RUN;
QUIT;
ODS PDF CLOSE;
ODS LISTING;

proc sql noprint; 
   drop table &d_plot; 
   drop table &d_1; 
quit;

%MEND boxplot;
/** \endcond */
