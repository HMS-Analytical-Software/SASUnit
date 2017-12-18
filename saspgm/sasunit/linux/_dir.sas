/** \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

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

%MACRO _dir (i_path=
            ,i_recursive=0
            ,o_out=work.dir
            );

   %LOCAL dirfile encoding s l_i_path l_i_name;

   data &o_out ;
       length filename $255;
       format changed datetime20.;
   run;

   %IF &syserr NE 0 %THEN %GOTO errexit;

   %LET encoding=wlatin1;

   %put &g_note.(SASUNIT): Directory search is:           &i_path;

   %*** Change backslashes to slashes ***;
   %let l_i_path = %qsysfunc (translate (&i_path, /, \));

   %put &g_note.(SASUNIT): Corrected directory search is: &l_i_path;

   %*** remove quotes around the path ***;
   %if (%qsubstr(&l_i_path,1,1) = %str(%')) %then %do;
      %let l_i_path = %qsysfunc (compress(&l_i_path., %str(%')));
   %end;
   %if (%qsubstr(&l_i_path,1,1) = %str(%")) %then %do;
      %let l_i_path = %qsysfunc (compress(&l_i_path., %str(%")));
   %end;

   %let l_i_name=;

   %*** Look for wildcards an extract them ***;
   %if (%index (&l_i_path., %str(*)) > 0) %then %do;
      %let l_i_name=%qsysfunc(scan(&l_i_path, -1, /));
      %let l_i_path=%qsysfunc(substr(&l_i_path, 1, %qsysfunc(index (&l_i_path., &l_i_name.))-1));
      %let l_i_name = -name %str("")&l_i_name.%str("");
   %end;
   
   *** resolve macrovariables and macros if there are any   ***;
   *** unquote kills *.dat etc from the path                ***;
   *** So unquoting is done on the remaing part of the path ***;
   %if (%index (&l_i_path., %str (&)) > 0 OR %index (&l_i_path., %str(%%)) > 0) %then %do;
      %let l_i_path=%unquote (&l_i_path.);
   %end;
   %if (%index (&l_i_name., %str (&)) > 0 OR %index (&l_i_name., %str(%%)) > 0) %then %do;
      %let l_i_name=%unquote (&l_i_name.);
   %end;

   %put &g_note.(SASUNIT): Adjusted directory is:         &l_i_path;
   %put &g_note.(SASUNIT): Search pattern is    :         &l_i_name;

   %IF &i_recursive=0 %then %let s=-maxdepth 1;

   filename _dir pipe "find -P ""&l_i_path."" &s. &l_i_name. -type f -printf ""%nrstr(%h/%f\t%TD\t%TT\t\r\n)""" encoding=&encoding.;

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
