/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      partition a SAS dataset by groups, one data set per group

            By values and number of observations are written to data set labels

            Example for the application of assertLibrary.sas, see generate_test.sas.

\version    \$Revision: 38 $
\author     \$Author: mangold $
\date       \$Date: 2008-08-19 16:57:17 +0200 (Di, 19 Aug 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/example/saspgm/generate.sas $

\param      data   input data set
\param      by     by variable(s) for partitioning
\param      out    prefix for putput data sets, mubers will be appended
*/ /** \cond */ 

/* Änderungshistorie
   05.02.2008 AM Neuerstellung
*/ 

%MACRO generate(
   data   =
  ,by     =
  ,out    =
);

/*-- create local data sets and symbols --------------------------------------*/
%local d_temp1 d_temp2;
data; run; %let d_temp1=&syslast;
data; run; %let d_temp2=&syslast;
%local i count bycount;

/*-- sort input data set and check parameters --------------------------------*/
proc sort data=&data out=&d_temp1;
   by &by;
run;
%if &syserr %then %do;
   %put ERROR: Macro Generate: data= or by= specified incorrectly;
   %return;
%end;

/*-- determine groups --------------------------------------------------------*/
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

/*-- create data set labels --------------------------------------------------*/
data _null_;
   set &d_temp2 end=eof;
   array t(1) $ 200 _temporary_;
   t(1) = 'Dataset for';
%let i=1;
%do %while(%scan(&by,&i) ne %str());
   %if &i>1 %then %do;
   t(1) = trim(t(1)) !! ',';
   %end;
   t(1) = trim(t(1)) !! " %scan(&by,&i)=" !! trim(left(vvalue(%scan(&by,&i))));
   %let i = %eval(&i+1);
%end;
%let bycount=%eval(&i-1);
   t(1) = trim(t(1)) !! ' (' !! compress(put(_freq_,8.)) !! ' observations)';
   call symput ('label' !! compress(put(_n_,8.)), trim(t(1)));
run;

/*-- create output data sets -------------------------------------------------*/
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
