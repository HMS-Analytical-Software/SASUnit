/**
*/
%macro _insertAutoCallPath(autocallpath);
                             
   %local
     l_currentAutoCallPath
     l_found
   ;         

   %let l_currentAutoCallPath=%sysfunc (getoption (SASAUTOS));
   %_issueDebugMessage (&g_currentLogger., Searching for Autocallpath &autocallpath);
   
   %put ------>&=l_currentAutoCallPath.;

   %let l_found=%index (&l_currentAutoCallPath., &autocallpath.);
   %if (&l_found. > 0) %then %do;
      %_issueDebugMessage (&g_currentLogger., Autocallpath &autocallpath already set.);
   %end;
   %else %do;
      options append=(SASAUTOS=(&autocallpath.));
   %end;
%mend _insertAutoCallPath;
