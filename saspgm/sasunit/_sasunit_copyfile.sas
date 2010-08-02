/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      copy file byte by byte

               no error checking

   \%copyfile (input, output)

   \param   i_file   input file with complete path
   \param   o_file   output file with complete path

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
*/ /** \cond */

%MACRO _sasunit_copyFile (
    i_file  /* input file */
   ,o_file  /* output file */
);
DATA _null_;
   INFILE "&i_file" RECFM=N LRECL=1048576 LENGTH=l SHAREBUFFERS BLKSIZE=32768;
   FILE "&o_file" RECFM=N LRECL=32768 BLKSIZE=1048576;
   INPUT line $char32767.;
   PUT line $varying32767. l;
RUN;
%MEND _sasunit_copyFile;
 /** \endcond */
