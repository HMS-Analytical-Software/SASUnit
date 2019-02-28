/**
   \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      create a directory, if it does not exist
               The containing directory must exist. 

               \%mkdir(dir=directory)

               sets &sysrc to a value other than 0, when errors occured.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \todo document parameters
   \todo replace with dcreate in data _null_
   \todo move from sasunit_os to sasunit
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

*/ /** \cond */

%macro _mkdir(dir);

   %SYSEXEC(mkdir "&dir.");

%mend _mkdir; 

/** \endcond */

