/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      copy a complete directory tree.
               Uses Windows XCOPY or Unix cp

   \param   i_from       root of directory tree
   \param   i_to         copy to 
   \return  operation system return code or 0 if OK

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

/* change history
   02.10.2008 NA  Anpassung an Linux
*/ 

%macro _sasunit_copyDir(
   i_from
  ,i_to
);

%if &sysscp. = WIN %then %do; 

   /* save and modify os command options */
   %local xwait xsync xmin;
   %let xwait=%sysfunc(getoption(xwait));
   %let xsync=%sysfunc(getoption(xsync));
   %let xmin =%sysfunc(getoption(xmin));
   options noxwait xsync xmin;

   %let i_from = %qsysfunc(translate(&i_from,\,/));
   %let i_to   = %qsysfunc(translate(&i_to  ,\,/));

   /*-- XCOPY
        /E copy directories (even empty ones) and files recursively 
        /I do not prompt before file or directory creation
        /Y do not prompt before overwriting target
     --*/
   %sysexec 
      xcopy
         "&i_from"
         "&i_to"
         /E /I /Y
   ;
   %put sysrc=&sysrc;
   options &xwait &xsync &xmin;
%end;

%else %if &sysscp. = LINUX %then %do;
   %SYSEXEC(cp -R &i_from. &i_to.);
%end;

%mend _sasunit_copyDir;
/** \endcond */
