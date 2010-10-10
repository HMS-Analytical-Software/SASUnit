/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Programmbeschreibung aus dem Doxygen-Brief-Tag ermitteln

   \param   i_pgmfile Pfad zur Programmdatei
   \param   r_desc Name der Makrovariable, in der die Beschreibung zurückgegeben wird
   \return  Beschreibungstext

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

/* History
   02.10.2008 NA  modified for LINUX
*/ 

%MACRO _sasunit_getPgmDesc (
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

%MEND _sasunit_getPgmDesc;
/** \endcond */
