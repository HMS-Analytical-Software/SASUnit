/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      copy file byte by byte

               no error checking

   \%_copyfile (input, output)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
            
   \param   i_file   input file with complete path
   \param   o_file   output file with complete path

   \remark   fcopy is only valid in SAS 9.4. Not in SAS 9.3.
*/ /** \cond */
%MACRO _copyFile (i_file  /* input file */
                 ,o_file  /* output file */
                 );

   %if (%sysfunc (fileexist (&i_file.))) %then %do;
/*      filename _src "&i_file" RECFM=N;
      filename _tgt "&o_file" RECFM=N;
      %let rc = %sysfunc (fcopy (_src, _tgt));*/
      DATA _null_;
         INFILE "&i_file" RECFM=N LRECL=1048576 LENGTH=l SHAREBUFFERS BLKSIZE=32768;
         FILE "&o_file" RECFM=N LRECL=32768 BLKSIZE=1048576;
         INPUT line $char32767.;
         PUT line $varying32767. l;
      RUN;
   %end;
   %else %do;
      %_issueInfoMessage (&g_currentLogger.,_copyFile: File "&i_file" does not exist. Target file will not be present.);
   %end;
%MEND _copyFile;
 /** \endcond */