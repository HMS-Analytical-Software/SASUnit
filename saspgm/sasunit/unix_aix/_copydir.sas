/** \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      copy a complete directory tree.
               Uses Windows XCOPY or Unix cp

   \param   i_from       root of directory tree
   \param   i_to         copy to 
   \return  operation system return code or 0 if OK

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

%macro _copyDir(i_from
               ,i_to
               );

   %SYSEXEC(cp -R &i_from. &i_to.);

%mend _copyDir;
/** \endcond */
