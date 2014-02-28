/** \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      generates a dataset with the names of all files in a directory or directory tree.
               Wildcards may be used to specify the files to be included

               Resulting SAS dataset has the columns
               filename (name of file with absolute path, path separator is slash) 
               changed (last modification data as SAS datetime).

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$

   \param   i_path       name of directory or file group (containing wildcards) with full path
   \param   i_recursive  1 .. search recursively in subdirectories, default is 0
   \param   o_out        output dataset, default is work.dir. This dataset contains two columns
                         named filename and changed

*/ /** \cond */

%MACRO _dir(i_path=
           ,i_recursive=0
           ,o_out=dir
           );

   %LOCAL dirfile encoding s l_i_path;

   proc sql noprint;
      create table &o_out (filename char(255));
   quit;

   %IF (not %sysfunc (exist (&o_out))) %THEN %GOTO errexit;

   %let encoding=pcoem850;
   %let s =;
   %let dirfile=%sysfunc(pathname(work))/&o_out..dir.txt;
   filename _dirfile "&dirfile" encoding=&encoding;

   %put &g_note.(SASUNIT): Directory search is: &i_path;

   %let l_i_path=%qsysfunc(tranwrd(&i_path, %str( ), %str(\ )));

   %IF &i_recursive=0 %then
        %let s = -prune;

   %let search = %qscan(&l_i_path.,-1,'/');
   %let k = %index(&l_i_path.,%qtrim(&search.));
   %let path = %qsubstr(&l_i_path.,1,%eval(&k.-2));
   %if %qsubstr(&path.,1,1) eq %str(%') %then
       %let path = &path.%str(%');
   %if %qsubstr(&path.,1,1) eq %str(%") %then
       %let path = &path.%str(%");

   %SYSEXEC(find &path. -name "&search." -ls &s. -type f > &dirfile.);

   data &o_out (keep=filename changed);
      array dum{7} $;
      array dat{3} $;
      length filename $255
             fileall  $1024
             ;
      format changed datetime20.;
      infile _dirfile delimiter=' ' truncover;
      input dum1-dum7 $ dat1-dat3 $ fileall $;
      filename = fileall;
      if substr(dum3,1,1)='d' then delete;
      if index(dat3,':') gt 0 then do;
         changed = input(compress(dat2 || dat1 || year(today())) || " " || dat3, datetime.);
         if changed gt today() then do;
            changed = input(compress(dat2 || dat1 || year(today())-1) || " " || dat3, datetime.);
         end;
      end;
      else do;
         changed =input(compress( dat2 || dat1 || dat3) || " 00:00", datetime.);
      end;
   run;

%errexit:
%MEND _dir;
/** \endcond */

