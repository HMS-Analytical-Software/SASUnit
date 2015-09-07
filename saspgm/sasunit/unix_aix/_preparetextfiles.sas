/** \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      corrects termstring in textfiles. Under Linux CRLF will be converted to CR

   \%_prepareTextFiles

   \return  corrected textfiles

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

%MACRO _prepareTextFiles; 

   %_xcmd(sed -e 's/\r//g' "&g_sasunit/_nls.txt" > ~/temp.; mv ~/temp. "&g_sasunit/_nls.txt");   
%MEND _prepareTextFiles;
/** \endcond */
