/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      löscht eine externe Datei, wenn sie existiert. 

   \%delfile (datei)

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007

   \param   i_file   Pfad und voller Name der zu löschenden Datei

   \return           gibt 0 zurück wenn OK, sonst SAS-Fehlercode
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
