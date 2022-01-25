/**
   \file
   \ingroup    SASUNIT_SCN

   \brief      Add a path or fileref to the autocall facility.
               Can be a path with a folder or an SAS fileref. Any string that is equal or less than eight characters in length is checked to be a valid fileref.
               If it is then the fileref is inserted otherwise the string is enclosed in double quotes and inserted.               

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      autocallpath   Path or fileref that should be inserted.
*/ /** \cond */ 
%macro _insertAutoCallPath(autocallpath);
                             
      %local
        l_currentAutoCallPath
        l_found
        l_autoCallPath
        l_paramIsFileRef
      ;         
      
      %if (%length(&autocallpath.)=0) %then %goto exit;

      %_issueTraceMessage (&g_currentLogger., Searching for Autocallpath &autocallpath);

      %let l_currentAutoCallPath=%sysfunc (getoption (SASAUTOS));
      %let l_found=%sysfunc (findw (&l_currentAutoCallPath., &autocallpath., %str(% %"%(%)), I));
      
      %if (&l_found. > 0) %then %do;
         %_issueDebugMessage (&g_currentLogger., Autocallpath &autocallpath already set.);
      %end;
      %else %do;
         %let l_paramIsFileRef = 0;
         %if (%length(&autocallpath.) <= 8) %then %do;
             %let l_paramIsFileRef = %eval(%sysfunc (fileref (&autocallpath.))=0);
         %end;
         
         %if (&l_paramIsFileRef.) %then %do;
            options append=(SASAUTOS=(&autocallpath.));
         %end;
         %else %do;
            options append=(SASAUTOS=("&autocallpath."));
         %end;
      %end;
      
   %exit:
%mend _insertAutoCallPath;
/** \endcond **/