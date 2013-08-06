/**
\file
\ingroup    SASUNIT_UTIL

\brief      macro symbols for national language support

            macro symbol names follow the convention g_nls_yyyy_zzz, where 
            yyyy is a name of the macro program where the symbol is used (without prefix _ and 
            without suffix HTML) 
            and zzz is the symbol number within the macro program

\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

\param      i_language EN or DE
\return     macro symbols in global symbol table
*/ /** \cond */ 

data nls (drop=mark);
   infile "&g_sasunit./_nls.txt" truncover termstr=crlf;
   input mark $3. @;
   if mark ne '###' then do;
      if mark='---' then input @4 program $32.;
      retain program;  
      input @1 num 3. +1 language $2. +1 text $128.;
      output;
   end;
run; 

%MACRO _nls (i_language = 
            );

   data _null_;
      set nls;
      where language = "&i_language";
      call execute ('%global g_nls_' !! trim(program) !! '_' !! put (num, z3.) !! ';');
      call symput ('g_nls_' !! trim(program) !! '_' !! put (num, z3.), trim (text));
   run; 

%MEND _nls;
/** \endcond */
