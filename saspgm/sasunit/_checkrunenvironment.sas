/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      This macro checks operating system and sas version against the requirments of the current implementation 


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
            
   \param   o_result  name of macro variable
                      0 (default).. no results written to SAS log
                      1 .. results are written to SAS log
   
*/ /** \cond */ 
%macro _checkRunEnvironment;
   %local l_result l_macname;

   %*** initalize local variables ***;
   %let l_result=0;
   %let l_macname=&sysmacroname.;


   %*** check for operation system ***;
   %if %_handleError(&l_macname.
                    ,WrongOS
                    ,(%upcase(&sysscp.) NE WIN) AND (%upcase(&sysscpl.) NE LINUX) AND (%upcase(&sysscpl.) NE AIX)
                    ,Invalid operating system - only WINDOWS%str(,) LINUX AND AIX
                    ) 
   %then %let l_result=1;

   %*** check SAS version ***;
   %if %_handleError(&l_macname.
                    ,WrongVer
                    ,(&sysver. NE 9.3) AND (&sysver. NE 9.4) AND (&sysver. NE V.04.00)
                    ,Invalid SAS version - only SAS 9.3 and 9.4 and Viya
                    ) 
   %then %let l_result=1;

   &l_result.
%mend _checkRunEnvironment;
/** \endcond */
