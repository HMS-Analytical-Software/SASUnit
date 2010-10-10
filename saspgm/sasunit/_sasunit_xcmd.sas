/** \file
   \ingroup    SASUNIT_UTIL

   \brief      run an operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   cmd     OS command with quotes where necessary 
   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.

 */ /** \cond */ 

/* change history
   02.10.2008 NA  Anpassung an Linux
*/ 

%macro _sasunit_xcmd(i_cmd);
%if &sysscp. = WIN %then %do; 
	%local xwait xsync xmin;
	%let xwait=%sysfunc(getoption(xwait));
	%let xsync=%sysfunc(getoption(xsync));
	%let xmin =%sysfunc(getoption(xmin));

	options noxwait xsync xmin;

	%SYSEXEC &i_cmd;

	options &xwait &xsync &xmin;
%end;

%else %if &sysscp. = LINUX %then %do;
	%SYSEXEC &i_cmd;
%end;

%mend _sasunit_xcmd; 

/** \endcond */

