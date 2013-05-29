/** \file
   \ingroup    SASUNIT_UTIL 

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

%MACRO _sasunit_dir(
    i_path=
   ,i_recursive=0
   ,o_out=dir
);

%if &sysscp. = WIN %then %do; 
   %local dirindicator_en dirindicator_de encoding;
   %let dirindicator_en=Directory of;
   %let dirindicator_de=Verzeichnis von;
   %let encoding=pcoem850;
   %let i_path = %sysfunc(translate(&i_path,\,/));
	 
   proc sql noprint;
      create table &o_out (filename char(255));
   quit;
   %IF &syserr NE 0 %THEN %GOTO errexit;

   %local xwait xsync xmin;
   %let xwait=%sysfunc(getoption(xwait));
   %let xsync=%sysfunc(getoption(xsync));
   %let xmin =%sysfunc(getoption(xmin));

   options noxwait xsync xmin;
   
   %local dirfile;
   %let dirfile=%sysfunc(pathname(work))\___dir.txt;
   filename _dirfile "&dirfile" encoding=&encoding;
   %local s;
   %IF &i_recursive %then %let s=/S;
   %put SYSEXEC(dir &s "&i_path" > "&dirfile");
   %SYSEXEC(dir &s /a-d "&i_path" > "&dirfile");
   
   options &xwait &xsync &xmin;
   
   data &o_out (keep=filename changed);
      length dir filename $255 language $2;
      retain language "__" dir FilePos;
      infile _dirfile truncover;
      input line $char255. @;
      if index (line, "&dirindicator_en") or index (line, "&dirindicator_de") then do;
         if index (line, "&dirindicator_en") then do;
            dir = substr(line, index (line, "&dirindicator_en")+length("&dirindicator_en")+1);
         end;
         else do;
            dir = substr(line, index (line, "&dirindicator_de")+length("&dirindicator_de")+1);
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
            end;
            else do;
               Filenamepart = scan (line,4, " ");
               Filepos      = index (line, trim(Filenamepart));
               language     = "DE";
            end;
         end;
         if language='DE' then do;
            input @1
               d ddmmyy10. +2
               t time5.
            ;
         end;
         else do;
            input @1
               d mmddyy10. +2
               t time9.
            ;
         end;
         changed  = dhms (d, hour(t), minute(t), 0);
         format changed datetime20.;
         filename = translate(trim(dir) !! '/' !! substr (line,FilePos),'/','\');
         output;
      end;
   run;
   
   filename _dirfile;
%end; /* &sysscp. = WIN */
 
%else %if &sysscp. = LINUX %then %do;

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

%end; /* &sysscp. = LINUX */

%errexit:
%MEND _sasunit_dir;
/** \endcond */

