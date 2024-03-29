/**
   \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      execute an command file by operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

   \param   i_cmdFile            Command file to be executed by the OS
   \param   i_operator           Operator for evaluation of the shell command return code
   \param   i_expected_shell_rc  Command file to be executed by the OS

*/ 
/** \cond */ 

%macro _executeCMDFile(i_cmdFile
                      ,i_operator
                      ,i_expected_shell_rc
                      );
                 
   %_xcmd(chmod u+x "&i_cmdFile.")
   %_xcmd(sed -i -e 's/\r//g' "&i_cmdFile.");
   %_xcmd("&i_cmdFile.", &i_operator., &i_expected_shell_rc.)

%mend _executeCMDFile;   

/** \endcond */
