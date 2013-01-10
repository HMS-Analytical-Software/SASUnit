/**
    \file
    \ingroup  SASUNIT_UTIL

    \brief    determine the language dependant symbols used for NOTE, ERROR, WARNING in the SAS log
    \param    r_note_symbol name of macro variable used to return the symbol for NOTE 
                            (default note_symbol)
    \param    r_warning_symbol name of macro variable used to return the symbol for WARNING
                            (default warning_symbol)
    \param    r_error_symbol name of macro variable used to return the symbol for ERROR
                            (default error_symbol)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%MACRO _sasunit_detectSymbols(
    r_note_symbol    = note_symbol
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

%MEND _sasunit_detectSymbols;
/** \endcond */
