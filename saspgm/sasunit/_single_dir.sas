/** \file
   \ingroup    SASUNIT_UTIL

   \brief      Generates a dataset with the names of all files in a directory.
               Wildcards may be used to specify the files to be included

               Resulting SAS dataset has the columns
               membername (name of the file in the directory)
               filename (name of file with absolute path, path separator is slash) 
               changed (last modification data as SAS datetime).

   \version    \$Revision: 480 $
   \author     \$Author: klandwich $
   \date       \$Date: 2016-11-25 09:52:29 +0100 (Fr, 25 Nov 2016) $
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/windows/_dir.sas $
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_path       name of directory in which to search
   \param   i_pattern    name of file to be search or name with widlcards
   \param   o_out        output dataset, default is work.dir. This dataset contains two columns
                         named filename and changed

*/ /** \cond */ 

%MACRO _single_dir (i_path=
                   ,i_pattern=_NONE_
                   ,o_out=dir
                   );

   %local l_i_path l_i_pattern;

   %let l_i_path = %sysfunc(dequote(&i_path.));
   %let l_i_path = %sysfunc(translate(&l_i_path,/,\));

   %let l_i_pattern=%qupcase(&i_pattern);
   %if ("&l_i_pattern" ne "_NONE_") %then %do;
      %put &g_note.(SASUNIT): Given pattern was found: &l_i_pattern.;
      %let l_i_pattern = %sysfunc(dequote (&l_i_pattern.)); 
      %let l_i_pattern = %sysfunc(translate (&l_i_pattern., %str(%%), %str(*))); 
      %let l_i_pattern = %sysfunc(translate (&l_i_pattern., _, ?)); 
      %put &g_note.(SASUNIT): Modified pattern: &l_i_pattern.;
   %end;

   data work._sdir_1
      %if (&l_i_pattern. ne _NONE_) %then %do;
         (where=(upcase (membername) like "&l_i_pattern."))
      %end;
   ;
      length membername filename $255;

      pattern = "&l_i_pattern.";
      rc = filename ("DIR", "&l_i_path.");
      directory = catt("&l_i_path.");
      putlog directory=;
      if (substr (directory, length (directory),1) = "/") then do;
         directory = substr (directory,1,length(directory)-1);
      end;
      putlog directory=;
      if (rc ne 0) then do;
         putlog "&g_error.(SASUNIT): Given directory does not exist: '&l_i_path.'";
      end;
      else do;
         d_id = dopen ("DIR");
         if (d_id > 0) then do;
            putlog "&g_note.(SASUNIT): Given directory was found: '&l_i_path.'";
         end;
         else do;
            putlog "&g_error.(SASUNIT): Given directory does not exist: '&l_i_path.'";
            rc = filename ("DIR", "");
            STOP;
         end;
         num  = dnum(d_id);
         if (num < 1) then do;
            putlog "&g_note.(SASUNIT): Given directory is empty.";
         end;
         else do;
            putlog "&g_note.(SASUNIT): Given directory contains " num "entries.";
         end;
         do i=1 to num;
            membername = dread (d_id, i);
            filename = catx ("/", directory, membername);
            fileref  = "_SF" !! put (i,z5.);
            rc = filename (fileref, filename);
            d_dir_id = dopen (fileref);
            if (d_dir_id <= 0) then do;
               output;
            end;
            else do;
               d_dir_id = dclose (d_dir_id);
               putlog "&g_note.(SASUNIT): Given directory contains subdirectory '" membername +(-1) "'";
               rc = filename (fileref, "");
            end;
         end;
         d_id = dclose (d_id);
      end;
      rc = filename ("DIR", "");
      keep fileref filename membername;
   run;

   proc sql noprint;
      create table work._sdir_2 as 
         select d.*
               ,v.modate as changed format=datetime20. informat=datetime.
         from work._sdir_1 d left join sashelp.vextfl v
         on d.fileref = v.fileref;
   quit;

   data _null_;
      set work._sdir_2;
      rc = filename (fileref, "");
   run;

   data &o_out.;
      set work._sdir_2 (drop=fileref);
   run;
%MEND _single_dir;
