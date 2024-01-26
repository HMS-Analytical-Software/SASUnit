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
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
            
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
   %let l_i_path   = %_makeSASUnitPath(&i_path.);
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
      %_issueInfoMessage (&g_currentLogger.,_noxcmd_dir: Given directory does not exist or file pattern has no matches: &l_i_path.);
	  %if (&i_recursive = 0) %then %do;
         filename DIR clear;
         %goto exit;
	  %end;
   %end;
   %let l_dir_id = %sysfunc (dopen(DIR));
   %if (&l_dir_id <= 0) %then %do;
      %_issueInfoMessage (&g_currentLogger.,_noxcmd_dir: Given path is valid but may contain filepattern: &l_i_path.);
      %let l_i_pattern =%qscan (&l_i_path.,-1,/);
      %let l_i_path    =%substr (&l_i_path.,1,%index(&l_i_path., &l_i_pattern.)-2);
      %let l_i_pattern =%upcase(&l_i_pattern);

      *** Using like operator. It uses the follwoing wildcards '%' and '_' ***;
      *** To search form them as literals they maust be escaped. I am using '^' ***;

      *** Save existing perecent signs and underscores with enclosing ^ and @ ***;
      %let l_i_pattern =%sysfunc(tranwrd (&l_i_pattern., %str(%%), %str(^%%@)));
      %let l_i_pattern =%sysfunc(tranwrd (&l_i_pattern., %str(_), %str(^_@)));

      *** Change * and ? to % and _ ***;
      %let l_i_pattern =%qsysfunc(translate (&l_i_pattern., %str(%%), %str(*)));
      %let l_i_pattern =%qsysfunc(translate (&l_i_pattern., _, ?));

      *** Replace saved percent signs and undercores to ^% and ^_ ***;
      %let l_i_pattern =%qsysfunc(tranwrd (&l_i_pattern., %str(^%%@), %str(^%%)));
      %let l_i_pattern =%qsysfunc(tranwrd (&l_i_pattern., %str(^_@), %str(^_)));

      %let l_i_pattern =%sysfunc(translate (&l_i_pattern., %str(%%), %str(*))); 
      %let l_i_pattern =%sysfunc(translate (&l_i_pattern., _, ?)); 
      filename DIR clear;
      filename DIR "&l_i_path.";
      %let l_dir_id = %sysfunc (dopen(DIR));
      %if (&l_dir_id <= 0) %then %do;
         %_issueErrorMessage (&g_currentLogger.,_noxcmd_dir: Given path is not valid  : &l_i_path.);
         %_issueErrorMessage (&g_currentLogger.,_noxcmd_dir: Extracted file pattern is: &l_i_pattern.);
         %goto exit;
      %end;
      %_issueInfoMessage (&g_currentLogger.,_noxcmd_dir: Given path is valid      : &l_i_path.);
      %_issueInfoMessage (&g_currentLogger.,_noxcmd_dir: Extracted file pattern is: &l_i_pattern.);
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
