/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      Return number of observations in a SAS dataset.

            Return number of logical observations (deleted obeservations are not counted) in a SAS dataset.
            In case of an invalid dataset specification, a blank will be returned.

            Example: \%put \%nobs(dataset);

\version    \$Revision: 38 $
\author     \$Author: mangold $
\date       \$Date: 2008-08-19 16:57:17 +0200 (Di, 19 Aug 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/example/saspgm/nobs.sas $

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
