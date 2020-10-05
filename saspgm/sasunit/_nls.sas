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
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      i_language EN or DE
   
   \return     macro symbols in global symbol table
*/ /** \cond */ 
%MACRO _nls (i_language = 
            );

   data work.nls (drop=mark);
      infile "&g_sasunit./_nls.txt" truncover;
      input mark $3. @;
      if mark ne '###' then do;
         if mark='---' then input @4 program $32.;
         retain program;  
         input @1 num 3. +1 language $2. +1 text $128.;
         output;
      end;
   run; 

   data _null_;
      set work.nls;
      where language = "%upcase(&i_language.)";
      call execute ('%global g_nls_' !! trim(program) !! '_' !! put (num, z3.) !! ';');
      call symput ('g_nls_' !! trim(program) !! '_' !! put (num, z3.), trim (text));
   run; 

   proc datasets lib=work nolist;
      delete nls;
   run;
   quit;

%MEND _nls;
/** \endcond */