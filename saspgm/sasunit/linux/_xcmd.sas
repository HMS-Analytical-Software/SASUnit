/** \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      run an operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_cmd     OS command with quotes where necessary 
   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.

 */ /** \cond */ 

%macro _xcmd(i_cmd);

   %SYSEXEC &i_cmd;

%mend _xcmd; 

/** \endcond */

