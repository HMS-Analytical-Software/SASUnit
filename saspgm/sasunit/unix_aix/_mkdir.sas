/** \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      create a directory, if it does not exist
               The containing directory must exist. 

               \%mkdir(dir=directory)

               sets &sysrc to a value other than 0, when errors occured.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */

%macro _mkdir(dir);

   %SYSEXEC(mkdir "&dir.");
   /*%SYSEXEC(mkdir &dir.);*/

%mend _mkdir; 

/** \endcond */

