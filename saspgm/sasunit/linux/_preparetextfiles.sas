/** \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      corrects termstring in textfiles. Under Linux CRLF will be converted to CR

   \%_prepareTextFiles

   \return  corrected textfiles

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%MACRO _prepareTextFiles; 

      %_xcmd(sed -i -e 's/\r//g' "&g_sasunit/_nls.txt");
   
%MEND _prepareTextFiles;
/** \endcond */
