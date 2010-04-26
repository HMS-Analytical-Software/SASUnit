/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      binäres Kopieren einer externen Datei

               keine Fehlerbehandlung

   \%copyfile (eingabe, ausgabe)

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_file   Eingabedatei mit komplettem Pfad
   \param   o_file   Ausgabedatei mit komplettem Pfad
*/ /** \cond */

%MACRO _sasunit_copyFile (
    i_file  /* Eingabedatei */
   ,o_file  /* Ausgabedatei */
);
DATA _null_;
   INFILE "&i_file" RECFM=N LRECL=1048576 LENGTH=l SHAREBUFFERS BLKSIZE=32768;
   FILE "&o_file" RECFM=N LRECL=32768 BLKSIZE=1048576;
   INPUT line $char32767.;
   PUT line $varying32767. l;
RUN;
%MEND _sasunit_copyFile;
 /** \endcond */
