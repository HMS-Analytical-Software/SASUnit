/**
   \file
   \ingroup    SASUNIT_UTIL_OS_WIN

   \brief      macro function, that makes path contain only backslashes using translate function 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
*/ /** \cond */
%macro _adaptSASUnitPathToOS (path);
   %local l_path;
   %let l_path = %sysfunc (translate (&path., \, /));
   %if (%index (%quote(&l_path.), %str( ))) %then %do;
      %let l_path = %sysfunc(quote (&l_path.));
   %end;
   &l_path. 
%mend _adaptSASUnitPathToOS; 
/** \endcond */

