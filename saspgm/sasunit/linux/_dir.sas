/** \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      generates a dataset with the names of all files in a directory or directory tree.
               Wildcards may be used to specify the files to be included

               Resulting SAS dataset has the columns
               filename (name of file with absolute path, path separator is slash) 
               changed (last modification data as SAS datetime).

   \param   i_path       name of directory or file group (containing wildcards) with full path
   \param   i_recursive  1 .. search recursively in subdirectories, default is 0
   \param   o_out        output dataset, default is work.dir. This dataset contains two columns
                         named filename and changed

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.


*/ /** \cond */ 

%MACRO _dir (i_path=
            ,i_recursive=0
            ,o_out=dir
            );

   %LOCAL dirfile encoding s l_i_path;
   
   data &o_out ;
       length filename $255;
       format changed datetime20.;
   run;
   
   %IF &syserr NE 0 %THEN %GOTO errexit;

   %LET encoding=wlatin1;
   %LET dirfile=%sysfunc(pathname(work))/.dir.txt;
   filename _dirfile "&dirfile" encoding=&encoding;
    
   %put Directory search is: &i_path;
   %let l_i_path=%qsysfunc(tranwrd(&i_path, %str( ), %str(\ )));
   %IF &i_recursive=0 %then %let s=-maxdepth 1; 
   %SYSEXEC(find -P &l_i_path. &s. -type f -printf "%nrstr(%h/%f\t%TD\t%TT\t\r\n)" > &dirfile. 2>/dev/null);
   
   data &o_out (keep=filename changed);
       length filename $255;
       format changed datetime20.;
       infile _dirfile delimiter='09'x truncover;
       input filename $ d:mmddyy8. t:time8.; 
       changed = dhms (d, hour(t), minute(t), 0);
   run;

%errexit:
%MEND _dir;
/** \endcond */
