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
\sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

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
