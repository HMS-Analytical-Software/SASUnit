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

   %local s dirfile xwait xsync xmin l_i_path;

   %let l_i_path = %_makeSASunitPath (&i_path);
   %let l_i_path = %_adaptSASUnitPathToOS (&l_i_path.);
    
   proc sql noprint;
      create table &o_out (filename char(255));
   quit;
   %IF &syserr NE 0 %THEN %GOTO errexit;

   %let xwait=%sysfunc(getoption(xwait));
   %let xsync=%sysfunc(getoption(xsync));
   %let xmin =%sysfunc(getoption(xmin));

   options noxwait xsync xmin;
   
   %let dirfile=%sysfunc(pathname(work))\___dir.txt;

   %_issueDebugMessage (&g_currentLogger., _dir: Directory search is: &i_path.);
   %_issueDebugMessage (&g_currentLogger., _dir: Adjusted directory is: &l_i_path.);

   %IF &i_recursive %then %let s=/S;
   
   %_issueTraceMessage (&g_currentLogger., _dir: %str(======== OS Command Start ========));
   /* Evaluate sysexec´s return code */
   %SYSEXEC(dir &s /a-d /on %unquote(&l_i_path.) > "&dirfile" 2>&1);
   %IF (&sysrc. = 0) %THEN %DO;
      %_issueTraceMessage (&g_currentLogger., _dir: Sysrc : &sysrc. -> SYSEXEC SUCCESSFUL);
   %END;
   %ELSE %IF (&sysrc. = 1) %THEN %DO;
      %_issueTraceMessage (&g_currentLogger., _dir: Sysrc : &sysrc. -> SYSEXEC SUCCESSFUL);
      %_issueTraceMessage (&g_currentLogger., _dir: Directory is empty);
   %END;
   %ELSE %DO;
      %_issueErrorMessage (&g_currentLogger., _dir: &sysrc -> An Error occured);
   %END;

   /* put sysexec command to log*/
   %_issueTraceMessage (&g_currentLogger., _dir: SYSEXEC COMMAND IS: dir &s /a-d /on &l_i_path > &dirfile);
   
   %if (&g_currentLogLevel. = TRACE) %then %do;
      /* write &dirfile to the log*/
      data _null_;
         infile "&dirfile" truncover lrecl=512;
         input line $512.;
         putlog line;
      run;
   %end;

   %_issueTraceMessage (&g_currentLogger., _dir: %str(======== OS Command End ========));
   
   %SYSEXEC(dir &s /a-d /on %unquote(&l_i_path.) > "&dirfile");
   options &xwait &xsync &xmin;
   
   %_readdirfile (i_dirfile =&dirfile.
                 ,i_encoding=&g_OSEncoding.
                 ,o_out     =&o_out.
                 );   

%errexit:
%MEND _dir;
/** \endcond */

