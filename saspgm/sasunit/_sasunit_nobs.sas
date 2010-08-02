/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Returns number of observations in a SAS dataset

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_data       SAS dataset (one or two level name) 
   \return  number of observations or 0, if dataset cannot be found
*/ /** \cond */ 

/* change log
   07.02.2008 AM  return logical instead of physical observations
*/ 

%MACRO _sasunit_nobs(
    i_data
);
%local dsid nobs;
%let nobs=0;
%let dsid=%sysfunc(open(&i_data));
%if &dsid>0 %then %do;
   %let nobs=%sysfunc(attrn(&dsid,nlobs));
   %let dsid=%sysfunc(close(&dsid));
%end;
&nobs
%MEND _sasunit_nobs;
/** \endcond */
