/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Prüft, ob ein Verzeichnis existiert. 

   \%existDir(verzeichnis)

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_dir     kompletter Pfad zu einem zu prüfenden Verzeichnis
   \return  1 .. Verzeichnis existiert, 0 .. existiert nicht
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
