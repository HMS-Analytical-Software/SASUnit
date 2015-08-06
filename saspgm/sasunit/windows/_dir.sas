/** \file
   \ingroup    SASUNIT_UTIL_OS_WIN

   \brief      Generates a dataset with the names of all files in a directory or directory tree.
               Wildcards may be used to specify the files to be included

               Resulting SAS dataset has the columns
               filename (name of file with absolute path, path separator is slash) 
               changed (last modification data as SAS datetime).

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_path       name of directory or file group (containing wildcards) with full path
   \param   i_recursive  1 .. search recursively in subdirectories, default is 0
   \param   o_out        output dataset, default is work.dir. This dataset contains two columns
                         named filename and changed

*/ /** \cond */ 

%MACRO _dir (i_path=
            ,i_recursive=0
            ,o_out=dir
            );

   %local encoding s dirfile xwait xsync xmin l_i_path l_cmd;
   %let encoding=pcoem850;
   %let l_i_path = %sysfunc(translate(&i_path,\,/));
    
   proc sql noprint;
      create table &o_out (filename char(255));
   quit;
   %IF &syserr NE 0 %THEN %GOTO errexit;

   %let xwait=%sysfunc(getoption(xwait));
   %let xsync=%sysfunc(getoption(xsync));
   %let xmin =%sysfunc(getoption(xmin));

   options noxwait xsync xmin;
   
   %let dirfile=%sysfunc(pathname(work))\___dir.txt;
   filename _dirfile "&dirfile" encoding=&encoding;

   %let l_cmd=%nrstr (for %g in %(%")&l_i_path.%nrstr(%"%) do @echo %~tg %~fg);
   %if &i_recursive %then %do;
      %let s=/S;
      %let l_cmd=%nrstr (for /F %g in %(%'dir /S /b) &l_i_path.%nrstr(%'%) do @echo %~tg %~fg);
   %end;
   
   %if &g_verbose. %then %do;
      %put ======== OS Command Start ========;
      /* Evaluate sysexec´s return code */
      %SYSEXEC(&l_cmd. >> "&dirfile" 2>&1);
      %if &sysrc. = 0 %then %put &g_note.(SASUNIT): Sysrc : 0 -> SYSEXEC SUCCESSFUL;
      %else %put &g_error.(SASUNIT): Sysrc : &sysrc -> An Error occured;

      /* put sysexec command to log*/
      %put &g_note.(SASUNIT): SYSEXEC COMMAND IS: &l_cmd. > "&dirfile";
      
      /* write &dirfile to the log*/
      data _null_;
         infile "&dirfile" truncover lrecl=512;
         input line $512.;
         putlog line;
      run;
      %put ======== OS Command End ========;
      %SYSEXEC (del "&dirfile.");
   %end;
   
   %SYSEXEC(&l_cmd. >> "&dirfile");
   
   data &o_out (keep=membername filename changed);
      length membername dir filename $255 language $2 tstring dateformat timeformat $40;
      retain language "__" dir FilePos dateformat timeformat Detect_AM_PM ;
      infile _dirfile truncover;
      input line $char255.;
      if (_N_ = 4) then do;
         dir = scan (line, 3, ' ');
         idx = index (trim(line), trim(dir));
         dir = substr (trim (line), idx);
      end;
      if substr(line,1,1) ne ' ' then do;
         * Check for presence of AM/PM in time value, because you can specify AM/PM timeformat in German Windows *;
         if (language = "__") then do;
            Detect_AM_PM = upcase (scan (line, 3, " "));
            if (Detect_AM_PM in ("AM", "PM")) then do;
               Filenamepart = scan (line,4, " ");
               Filepos      = index (line, trim(Filenamepart));
               language     = "EN";
               dateformat   = "mmddyy10.";
               timeformat   = "time9.";
            end;
            else do;
               Filenamepart = scan (line,3, " ");
               Filepos      = index (line, trim(Filenamepart));
               language     = "DE";
               dateformat   = "ddmmyy10.";
               timeformat   = "time5.";
            end;
         end;
         if ("&G_DATEFORMAT." ne "_NONE_") then do;
            dateformat   = "&G_DATEFORMAT.";
            line         = tranwrd (line, "Mrz", "Mär");
         end;
         d          = inputn (scan (line,1,' '), dateformat);
         tstring    = trim (scan (line,2,' '));
         if (Detect_AM_PM in ("AM", "PM")) then do;
            tstring = trim (scan (line,2,' ')) !! ' ' !! trim (scan (line, 3, ' '));
         end;
         t          = inputn (tstring,           timeformat);
         changed    = dhms (d, hour(t), minute(t), 0);
         format changed datetime20.;
         filename   = trim (translate(substr (line,FilePos),'/','\'));
         pos        = find (filename, '/', -length(filename))+1;
         membername = substr (filename,Pos);         
         output;
      end;
   run;
   
   filename _dirfile;

   %SYSEXEC (del "&dirfile.");

   options &xwait &xsync &xmin;

%errexit:
%MEND _dir;
/** \endcond */

