/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      Return number of observations in a SAS dataset.

            Return number of logical observations (deleted obeservations are not counted) in a SAS dataset.
            In case of an invalid dataset specification, a blank will be returned.

            Example: \%put \%nobs(dataset);

\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$

\param      data SAS dataset to count observations from
\return     number of observations in input dataset
*/ /** \cond */ 

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
