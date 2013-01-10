/** \file
   \ingroup    SASUNIT_UTIL

   \brief      create a directory, if it does not exist
               The containing directory must exist. 

               \%mkdir(dir=directory)

               sets &sysrc to a value other than 0, when errors occured.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */

/* change history
   05.09.2008 NA  Anpassung an Linux
*/ 

%macro _sasunit_mkdir(dir);

%if &sysscp. = WIN %then %do; 
   %local xwait xsync xmin;
   %let xwait=%sysfunc(getoption(xwait));
   %let xsync=%sysfunc(getoption(xsync));
   %let xmin =%sysfunc(getoption(xmin));

   options noxwait xsync xmin;

   %SYSEXEC(md "&dir");

   options &xwait &xsync &xmin;
%end;
%else %if &sysscp. = LINUX %then %do;
   %SYSEXEC(mkdir &dir.);
%end;

%mend _sasunit_mkdir; 

/** \endcond */

