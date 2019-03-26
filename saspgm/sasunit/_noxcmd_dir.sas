/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Generates a dataset with the names of all files in a directory or directory tree.
               Wildcards may be used to specify the files to be included

               Resulting SAS dataset has the columns
               membername (name of the file in the directory)
               filename (name of file with absolute path, path separator is slash) 
               changed (last modification data as SAS datetime).

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_path       name of directory or file group (containing wildcards) with full path
   \param   i_recursive  1 .. search recursively in subdirectories, default is 0
   \param   o_out        output dataset, default is work.dir. This dataset contains two columns
                         named filename and changed

*/ /** \cond */ 
%MACRO _noxcmd_dir (i_path=
                ,i_recursive=0
                ,o_out=dir
                );

   %local 
      l_i_path 
      l_i_pattern
      l_dir_id
      l_rc
      l_nobs
   ;

   *** make path look alike under all OSs ***;
   %let l_i_path   = %qsysfunc(translate(%qsysfunc(dequote(&i_path.)),/,\));
   %let l_i_pattern=_NONE_;

   *** Delete target dataset   ***;
   %if (%sysfunc (exist (&o_out., DATA))) %then %do;
      proc delete data=&o_out.;
      run;
   %end;
   %if (%sysfunc (exist (&o_out., VIEW))) %then %do;
      proc delete data=&o_out. MEMTYPE=(VIEW);
      run;
   %end;

   *** Check if path exists or contains file patterns ***;
   filename DIR "%unquote(&l_i_path.)";
   %let l_path_exists=%sysfunc (fileref (DIR));
   %if (&l_path_exists. ne 0) %then %do;
      %put &g_error.(SASUNIT): Given directory does not exist: &l_i_path.;
      filename DIR clear;
      %goto exit;
   %end;
   %let l_dir_id = %sysfunc (dopen(DIR));
   %if (&l_dir_id <= 0) %then %do;
      %put &g_note.(SASUNIT): Given path is valid but may contain filepattern: &l_i_path.;
      %let l_i_pattern =%qscan (&l_i_path.,-1,/);
      %let l_i_path    =%substr (&l_i_path.,1,%index(&l_i_path., &l_i_pattern.)-2);
      %let l_i_pattern =%upcase(&l_i_pattern);
      %let l_i_pattern =%sysfunc(translate (&l_i_pattern., %str(%%), %str(*))); 
      %let l_i_pattern =%sysfunc(translate (&l_i_pattern., _, ?)); 
      filename DIR clear;
      filename DIR "&l_i_path.";
      %let l_dir_id = %sysfunc (dopen(DIR));
      %if (&l_dir_id <= 0) %then %do;
         %put &g_error.(SASUNIT): Given path is not valid  : &l_i_path.;
         %put &g_error.(SASUNIT): Extracted file pattern is: &l_i_pattern.;
         %goto exit;
      %end;
      %put &g_note.(SASUNIT): Given path is valid      : &l_i_path.;
      %put &g_note.(SASUNIT): Extracted file pattern is: &l_i_pattern.;
   %end;
   %let l_dir_id = %sysfunc (dclose(&l_dir_id.));
   filename DIR clear;

   *** Start reading directory ***;
   data work._nd_directories;
      length Directory $32000;
      Directory = catt(translate("&l_i_path.","/","\"));
      if (substr (Directory,length(Directory),1) = "/") then do;
         Directory = substr (Directory,1,length(Directory)-1);
      end;
   run;

   %if (&i_recursive. = 0) %then %do;
      %_single_dir (i_dsPath=work._nd_directories
                   ,i_pattern=&l_i_pattern.
                   ,o_members=&o_out.
                   );
   %end;
   %else %do;
      data _null_;
         set work._nd_directories nobs=anzahl;
         call symputx ("l_nobs", catt(anzahl), "L");
         stop;
      run;

      %do %while (&l_nobs. > 0);
         %let l_nobs = 0;
         %_single_dir (i_dsPath=work._nd_directories
                      ,i_pattern=&l_i_pattern.
                      ,o_members=work._nd_members
                      ,o_subdirs=work._nd_newdirs
                      );

         proc append base=&o_out. data=work._nd_members;
         run;

         data work._nd_directories;
            set work._nd_newdirs nobs=anzahl;
            Directory = filename;
            keep Directory;
            if (_N_ = 1) then do;
               call symputx ("l_nobs", catt(anzahl), "L");
            end;
         run;
      %end;
   %end;
%exit:
   proc datasets lib=work nolist;
      delete _nd_directories _nd_members _nd_newdirs;
   run;
   quit;
%MEND _noxcmd_dir;
/** \endcond **/