/** \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      copy a complete directory tree.
               Uses Windows XCOPY or Unix cp

   \param   i_from       root of directory tree
   \param   i_to         copy to 
   \return  operation system return code or 0 if OK

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.


*/ /** \cond */ 

%macro _copyDir (i_from
                ,i_to
                );

   %LOCAL l_i_from l_i_to;

   %let l_i_from = %qsysfunc(tranwrd(&i_from, %str( ), %str(\ )));
   %let l_i_to   = %qsysfunc(tranwrd(&i_to, %str( ), %str(\ )));

   %SYSEXEC(cp -R &l_i_from. &l_i_to.);

   %put &g_note.(SASUNIT): sysrc=&sysrc;
%mend _copyDir;
/** \endcond */
