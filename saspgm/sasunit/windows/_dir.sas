/**
   \file
   \ingroup    SASUNIT_UTIL_OS_WIN

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

   %local encoding s dirfile xwait xsync xmin l_i_path;
   %let encoding=pcoem850;

   %let l_i_path = %sysfunc(translate(&i_path,\,/));
   %let l_i_path = %sysfunc(dequote(&l_i_path.));
    
   proc sql noprint;
      create table &o_out (filename char(255));
   quit;
   %IF &syserr NE 0 %THEN %GOTO errexit;

   %let xwait=%sysfunc(getoption(xwait));
   %let xsync=%sysfunc(getoption(xsync));
   %let xmin =%sysfunc(getoption(xmin));

   options noxwait xsync xmin;
   
   %let dirfile=%sysfunc(pathname(work))\___dir.txt;

   %put &g_note.(SASUNIT): Directory search is: &i_path;
   %put &g_note.(SASUNIT): Adjusted directory is: &l_i_path;

   %IF &i_recursive %then %let s=/S;
   
   %if &g_verbose. %then %do;
      %put ======== OS Command Start ========;
      /* Evaluate sysexec´s return code */
      %SYSEXEC(dir &s /a-d "&l_i_path" > "&dirfile" 2>&1);
      %if &sysrc. = 0 %then %put &g_note.(SASUNIT): Sysrc : 0 -> SYSEXEC SUCCESSFUL;
      %else %put &g_error.(SASUNIT): Sysrc : &sysrc -> An Error occured;

      /* put sysexec command to log*/
      %put &g_note.(SASUNIT): SYSEXEC COMMAND IS: dir &s /a-d "&l_i_path" > "&dirfile";
      
      /* write &dirfile to the log*/
      data _null_;
         infile "&dirfile" truncover lrecl=512;
         input line $512.;
         putlog line;
      run;
      %put ======== OS Command End ========;
   %end;
   
   %SYSEXEC(dir &s /A-D /ON "&l_i_path" > "&dirfile");
   options &xwait &xsync &xmin;
   
   %_readdirfile (i_dirfile =&dirfile.
                 ,i_encoding=&encoding.
                 ,o_out     =&o_out.
                 );   

%errexit:
%MEND _dir;
/** \endcond */

