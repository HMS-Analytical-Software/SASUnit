/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      partition a SAS dataset by groups, one data set per group

            By values and number of observations are written to data set labels

            Example for the application of assertLibrary.sas, see generate_test.sas.

\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

\param      data   input data set
\param      by     by variable(s) for partitioning
\param      out    prefix for putput data sets, mubers will be appended
*/ /** \cond */

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
