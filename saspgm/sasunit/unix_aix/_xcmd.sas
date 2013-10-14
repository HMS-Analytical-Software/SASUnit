/** \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      run an operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   cmd     OS command with quotes where necessary 
   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.

 */ /** \cond */ 

%macro _xcmd(i_cmd);

   %SYSEXEC &i_cmd;

%mend _xcmd; 

/** \endcond */

