/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      return variable names for a SAS dataset

            Example: \%put \%getvars(dataset);

\version    \$Revision: 38 $
\author     \$Author: mangold $
\date       \$Date: 2008-08-19 16:57:17 +0200 (Di, 19 Aug 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/example/saspgm/getvars.sas $

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
