/**
    \file
    \ingroup  SASUNIT_UTIL

    \brief    determine the language dependant symbols used for NOTE, ERROR, WARNING in the SAS log
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
    \param    r_note_symbol name of macro variable used to return the symbol for NOTE 
                            (default note_symbol)
    \param    r_warning_symbol name of macro variable used to return the symbol for WARNING
                            (default warning_symbol)
    \param    r_error_symbol name of macro variable used to return the symbol for ERROR
                            (default error_symbol)

*/ /** \cond */ 

%MACRO _detectSymbols(r_note_symbol    = note_symbol
                     ,r_warning_symbol = warning_symbol
                     ,r_error_symbol   = error_symbol
                     );

   proc printto log=work.detect.note.log new;
   run;

   proc printto log=log;
   run;

   filename _detect catalog "work.detect.note.log";

   data _null_;
      infile _detect truncover;
      input line $char256.;
      call symput ("&r_note_symbol", scan(line, 1, ':'));
      stop;
   run;

   filename _detect;

   proc datasets lib=work nolist;
      delete detect / memtype=catalog;
   quit;

   %IF &&&r_note_symbol = HINWEIS %THEN %DO;
      %LET &r_warning_symbol = WARNUNG;
      %LET &r_error_symbol   = FEHLER;
   %END;
   %ELSE %DO;
      %LET &r_warning_symbol = WARNING;
      %LET &r_error_symbol   = ERROR;
   %END;

%MEND _detectSymbols;
/** \endcond */
