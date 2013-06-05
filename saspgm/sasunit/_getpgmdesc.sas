/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Programmbeschreibung aus dem Doxygen-Brief-Tag ermitteln

   \param   i_pgmfile Pfad zur Programmdatei
   \param   r_desc Name der Makrovariable, in der die Beschreibung zur�ckgegeben wird
   \return  Beschreibungstext

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%MACRO _getPgmDesc (
    i_pgmfile =
   ,r_desc    = desc
); 

%LET &r_desc=;
%IF NOT %sysfunc(fileexist(&i_pgmfile)) %THEN %RETURN;

data _null_;
   infile "&i_pgmfile" truncover end=eof;
   length desc $255;
   retain inbrief 0 desc;
   input line $255.;
   if upcase(line) =: '\BRIEF' then do;
      line = left (substr(line,7));
      inbrief=1;
   end;
   if substr(line,1,1)='\' or line=' ' or line='0D'x then inbrief=0;
   if inbrief then do;
      if desc=' ' then desc = line;
      else desc = trim(desc) !! ' ' !! line;
   end;
   if eof then call symput("&r_desc", trimn(desc));
run;

%MEND _getPgmDesc;
/** \endcond */