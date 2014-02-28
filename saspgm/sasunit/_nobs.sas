/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Returns number of observations in a SAS dataset

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_data       SAS dataset (one or two level name) 
   \return  number of observations or 0, if dataset cannot be found
*/ /** \cond */ 

%MACRO _nobs(i_data
            );

   %local dsid nobs;
   %let nobs=0;
   %let dsid=%sysfunc(open(&i_data));
   %if &dsid>0 %then %do;
      %let nobs=%sysfunc(attrn(&dsid,nlobs));
      %let dsid=%sysfunc(close(&dsid));
   %end;
&nobs
%MEND _nobs;
/** \endcond */
