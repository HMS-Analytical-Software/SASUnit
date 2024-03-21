/**
   \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      macro function, that makes path containing only slashes. For unix/aix nothing to do here. Backslahes are allowed for escaping characters. 

   \version    \$Revision: GitBranch: feature/jira-29-separate-SASUnit-files-from-project-source $
   \author     \$Author: landwich $
   \date       \$Date: 2024-03-13 11:25:41 (Mi, 13. März 2024) $
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the Lesser GPL license see included file readme.txt
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/readme/.
			   
   \todo    eliminate %PUT            
*/ /** \cond */
%macro _makeSASUnitPath (path);
   %local l_path;
   %let l_path=&path.;
   %if (%length (&path.) > 0) %then %do;
      %let l_path = %qsysfunc (dequote (&path.));
   %end;
   &l_path.
%mend _makeSASUnitPath; 
/** \endcond */

