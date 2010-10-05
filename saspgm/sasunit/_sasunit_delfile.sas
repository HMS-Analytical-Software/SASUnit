/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      delete an external file if it exists

   \%delfile (file)

   \param   i_file   full path and name of external file

   \return           0 if OK, system code otherwise

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
*/ /** \cond */ 

%MACRO _sasunit_delFile(
   i_file   
);

%LOCAL rc filrf;
%LET filrf=_tmpf;
%LET rc=%sysfunc(filename(filrf,&i_file));
%LET rc=%sysfunc(fdelete(_tmpf));
&rc
%LET rc=%sysfunc(filename(filrf));
%MEND _sasunit_delFile;
/** \endcond */
