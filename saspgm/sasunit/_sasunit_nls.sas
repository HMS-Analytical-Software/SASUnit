/**
\file
\ingroup    SASUNIT_UTIL

\brief      macro symbols for national language support

            macro symbol names follow the convention g_nls_yyyy_zzz, where 
            yyyy is a name of the macro program where the symbol is used (without prefix _sasunit_ and 
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

/* change log
   22-07-2008 AM  modified infile statement for linux
   13-08-2008 AM  created
*/ 

data nls (drop=mark);
   infile "&g_sasunit/_sasunit_nls.txt" truncover termstr=crlf;
   input mark $3. @;
   if mark='---' then input @4 program $32.;
   retain program;  
   input @1 num 3. +1 language $2. +1 text $128.;
run; 

%MACRO _sasunit_nls(
   i_language = 
);

data _null_;
   set nls;
   where language = "&i_language";
   call execute ('%global g_nls_' !! trim(program) !! '_' !! put (num, z3.) !! ';');
   call symput ('g_nls_' !! trim(program) !! '_' !! put (num, z3.), trim (text));
run; 

%MEND _sasunit_nls;
/** \endcond */
