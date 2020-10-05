/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      Retrieve program description from Doxygen brief tag

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_pgmfile Name and path of source code file
   \param   r_desc Name of the macro variable that holds the description

   \return  descriptive text of program

*/ /** \cond */ 
%MACRO _getPgmDesc (i_pgmfile =
                   ,r_desc    = desc
                   ); 

%LET &r_desc=&i_pgmfile.;
%IF NOT %sysfunc(fileexist(&i_pgmfile)) %THEN %RETURN;

   data _null_;
      infile "&i_pgmfile." truncover end=eof;
      length desc $1000;
      retain inbrief 0 desc;
      input line $1000.;
      if upcase(line) =: '\BRIEF' or upcase(line) =: '@BRIEF' then do;
         line = left (substr(line,7));
         inbrief=1;
      end;
      if substr(line,1,1)='\' or substr(line,1,1)='@' or line=' ' or line='0D'x then inbrief=0;
      if inbrief then do;
         if desc=' ' then desc = line;
         else desc = trim(desc) !! ' ' !! line;
      end;
      if eof then do;
         if desc = ' ' then desc ="&i_pgmfile.";
         call symput("&r_desc", trimn(desc));
      end;
   run;

%MEND _getPgmDesc;
/** \endcond */
