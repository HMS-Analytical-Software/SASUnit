/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      check whether directory exists 

   \%existDir(directory)

   \param   i_dir     complete path to directory to be checked
   \return  1 .. directory exists, 0 .. directory does not exists

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

%MACRO _sasunit_existDir(i_dir);
%LOCAL rc did filrf;
%LET filrf=_tmpf;
%LET rc=%sysfunc(filename(filrf,&i_dir));
%LET did=%sysfunc(dopen(_tmpf));
%IF &did NE 0 %THEN %DO;
   1
   %LET rc=%sysfunc(dclose(&did));
%END;
%ELSE %DO;
   0
%END;
%LET rc=%sysfunc(filename(filrf));
%MEND _sasunit_existDir;
/** \endcond */
