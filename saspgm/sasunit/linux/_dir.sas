/** \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      Generates a dataset with the names of all files in a directory or directory tree.
               Wildcards may be used to specify the files to be included

               Resulting SAS dataset has the columns
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

%MACRO _dir (i_path=
            ,i_recursive=0
            ,o_out=dir
            );

   %LOCAL dirfile encoding s l_i_path l_i_name;

   data &o_out ;
       length filename $255;
       format changed datetime20.;
   run;

   %IF &syserr NE 0 %THEN %GOTO errexit;

   %LET encoding=wlatin1;
   %LET dirfile=%sysfunc(pathname(work))/dir.txt;
   filename _dirfile "&dirfile" encoding=&encoding;

   %put &g_note.(SASUNIT): Directory search is: &i_path;

   %let l_i_path=%qsysfunc (dequote(&i_path.));
   %if (%index (&l_i_path., %str (%%))) > 0 %then %do;
      %let l_i_path=%unquote (&l_i_path.);
   %end;

   %let l_i_name=;

   %if (%index (&l_i_path., %str(*)) > 0) %then %do;
      %let l_i_name=%qsysfunc(scan(&l_i_path, -1, /));
      %let l_i_path=%qsysfunc(substr(&l_i_path, 1, %qsysfunc(index (&l_i_path., &l_i_name.))-1));
      %let l_i_name = -name %str("")&l_i_name.%str("");
   %end;
   %put &g_note.(SASUNIT): Adjusted directory is: &l_i_path;

   %IF &i_recursive=0 %then %let s=-maxdepth 1;

   filename _dir pipe "find -P ""&l_i_path."" &s. &l_i_name. -type f -printf ""%nrstr(%h/%f\t%TD\t%TT\t\r\n)""";

   data &o_out. (keep=membername filename changed);
      length membername filename $255;
      format changed datetime20.;
      infile _dir delimiter='09'x truncover;
      input filename $ d:mmddyy8. t:time8.;
      changed = dhms (d, hour(t), minute(t), 0);
      loca = length(filename) - length(scan(filename,-1,'/')) + 1;
      membername = substr(filename,loca);
   run;

   filename _dir clear;

   data &o_out.;
      set &o_out.;
      if (compress (upcase(filename)) =: 'FIND:') then do;
         stop;
      end;
   run;

   proc sort data=&o_out.;
      by filename;
   run;

%errexit:
%MEND _dir;
/** \endcond */
