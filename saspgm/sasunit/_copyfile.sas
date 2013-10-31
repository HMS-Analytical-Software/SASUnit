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
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */

%MACRO _copyFile (i_file  /* input file */
                 ,o_file  /* output file */
                 );
   DATA _null_;
      INFILE "&i_file" RECFM=N LRECL=1048576 LENGTH=l SHAREBUFFERS BLKSIZE=32768;
      FILE "&o_file" RECFM=N LRECL=32768 BLKSIZE=1048576;
      INPUT line $char32767.;
      PUT line $varying32767. l;
   RUN;
%MEND _copyFile;
 /** \endcond */
