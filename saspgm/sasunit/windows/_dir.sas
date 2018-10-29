/** \file
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
   filename _dirfile "&dirfile" encoding=&encoding;

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
   
   data &o_out (keep=membername filename changed);
      length membername dir filename $255 language $2 tstring dateformat timeformat $40;
      retain language "__" dir FilePos dateformat timeformat Detect_AM_PM;
      infile _dirfile truncover;
      input line $char255.;
      if index (line, ":\") then do;
         dir = substr(line, index (line, ":\")-1);
		 /* In Hungarian Windows the message is different                         */
		 /* - in English, German or French Windows the message looks like this    */
		 /*   <Word for Directory> <Word for of> <Directory>                      */
		 /* - in Hungarian and probably other Windows the message looks like this */
		 /*   <Directory> <Word for Directory ot whatever>                        */
		 /* Another problem is that dirctories with blanks are NOT quoted         */
		 /* We need to get rid of OS dir commands                                 */
         if index(dir, "tartalma") > 0 then do;
            dir = substr(line, 1, index (dir, "tartalma")-1);
         end;
      end;      
      if substr(line,1,1) ne ' ' then do;
         * Check for presence of AM/PM in time value, because you can specify AM/PM timeformat in German Windows *;
         if (language = "__") then do;
            Detect_AM_PM = upcase (scan (line, 3, " "));
            if (Detect_AM_PM in ("AM", "PM")) then do;
               Filenamepart = scan (line,5, " ");
               Filepos      = index (line, trim(Filenamepart));
               language     = "EN";
               dateformat   = "mmddyy10.";
               timeformat   = "time9.";
            end;
            else do;
               Filenamepart = scan (line,4, " ");
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
         changed  = dhms (d, hour(t), minute(t), 0);
         format changed datetime20.;
         membername = translate(substr (line,FilePos),'/','\');
         filename   = translate(trim(dir),'/','\') !! '/' !! membername;
         
         output;
      end;
   run;
   
   filename _dirfile;

%errexit:
%MEND _dir;
/** \endcond */

