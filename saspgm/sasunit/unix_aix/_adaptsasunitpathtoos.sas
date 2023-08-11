/**
   \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      macro function, that makes path contain only slashes. backslashes are allowed for escaping

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the Lesser GPL license see included file readme.txt
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/readme/.
			   
*/ /** \cond */
%macro _adaptSASUnitPathToOS (path);
   %local l_path;
   
   %*** escape all blanks with backslashes ***;
   %let l_path = %qsysfunc (tranwrd (&path., %str ( ), %str (\ )));
   %let l_path = %qsysfunc (tranwrd (&l_path., %str (\\ ), %str (\ )));
   &l_path.
%mend _adaptSASUnitPathToOS; 
/** \endcond */

