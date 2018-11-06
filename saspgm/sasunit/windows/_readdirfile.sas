/** \file
   \ingroup    SASUNIT_UTIL_OS_WIN

   \brief      Reads the text file comming from dir command.
               It supports mapped drives and new unc paths.
            In addition there is support for more languages.
            Thanks to user contribution of hungarian dir result.

               Resulting SAS dataset has the columns
               membername (name of the file in the directory)
               filename (name of file with absolute path, path separator is slash) 
               changed (last modification data as SAS datetime).

   \version    \$Revision: 616 $
   \author     \$Author: klandwich $
   \date       \$Date: 2018-10-29 11:56:33 +0100 (Mo, 29 Okt 2018) $
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/windows/_dir.sas $
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_path       name of directory or file group (containing wildcards) with full path
   \param   o_out        output dataset. This dataset has to exist.

*/ /** \cond */ 

%MACRO _readdirfile (i_dirfile =
                    ,i_encoding=
                    ,o_out     =
                    );


   filename _dirfile "&i_dirfile." encoding=&i_encoding;

   data &o_out (keep=membername filename changed);
      length membername dir filename $255 language $2 tstring dateformat timeformat $40;
      retain language "__" dir FilePos dateformat timeformat Detect_AM_PM;
      infile _dirfile truncover;
      input line $char255.;
      /* In Hungarian Windows the message is different                         */
      /* - in English, German or French Windows the message looks like this    */
      /*   <Word for Directory> <Word for of> <Directory>                      */
      /* - in Hungarian and probably other Windows the message looks like this */
      /*   <Directory> <Word for Directory or whatever>                        */
      /* Another problem is that dirctories with blanks are NOT quoted         */
      /* We need to get rid of OS dir commands                                 */
      if (substr (line, 3, 2) =":\"
          OR substr (line, 2, 2) ="\\") then do;        
        dir = trim(substr(line, 2, find (trim(line), " ", -300)-1));
      end;
      else do;
         if (index (line, ":\")) then do;
            dir = substr(line, index (line, ":\")-1);
         end;
         else if (index (line, "\\")) then do;
            dir = substr(line, index (line, "\\"));
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
%MEND _readdirfile;
/** \endcond */

