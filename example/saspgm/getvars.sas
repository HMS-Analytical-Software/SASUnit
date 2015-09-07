/**
   \file
   \ingroup    SASUNIT_EXAMPLES_PGM

   \brief      return variable names for a SAS dataset

               Example: \%put \%getvars(dataset);

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

   \param      data SAS dataset to return variable names from
   \param      dlm  delimiter, default is a blank
   \return     list of variable names from input dataset, separated by specified delimiter
*/ /** \cond */ 

%MACRO getvars(
   data
  ,dlm=
);
%local varlist dsid i;
%if "&dlm"="" %then %let dlm=%str( );
%let dsid = %sysfunc(open(&data));
%if &dsid %then %do ;
   %do i=1 %to %sysfunc(attrn(&dsid,NVARS));
      %if &i=1 %then 
         %let varlist = %sysfunc(varname(&dsid,&i));
      %else         
         %let varlist = &varlist.&dlm.%sysfunc(varname(&dsid,&i));
   %end;
   %let dsid = %sysfunc(close(&dsid));
%end;
&varlist
%MEND getvars;
/** \endcond */
