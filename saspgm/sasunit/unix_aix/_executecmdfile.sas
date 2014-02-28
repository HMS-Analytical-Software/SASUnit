/** \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      execute an command file by operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_cmdFile    Command file to be executed by the OS

*/ 
/** \cond */ 

%macro _executeCMDFile(i_cmdFile
                      );
                 
   %_xcmd(chmod u+x "&i_cmdFile.")
   %_xcmd(sed -e 's/\r//g' "&i_cmdFile." > ~/temp.; mv ~/temp. "&i_cmdFile.");
   %_xcmd("&i_cmdFile.")

%mend _executeCMDFile;   

/** \endcond */
