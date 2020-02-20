/**
*/
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
      %let l_found=%index (&l_currentAutoCallPath., &autocallpath.);
      
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
