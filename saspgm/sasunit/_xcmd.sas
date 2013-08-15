/** \file
   \ingroup    SASUNIT_UTIL

   \brief      run an operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_cmd     OS command with quotes where necessary 
   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.

 */ /** \cond */ 

%macro _xcmd(i_cmd);

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

%mend _xcmd; 

/** \endcond */

