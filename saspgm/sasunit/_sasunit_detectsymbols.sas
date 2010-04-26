/**
    \file
    \ingroup  SASUNIT_UTIL

    \brief    Ermitteln, welches Wort für NOTE verwendet wird, 
              dadurch kann die Log-Sprache festgestellt werden.
    \param    r_note_symbol Name der Makrovariable, die den Wert für NOTE zurückgibt 
                            (Voreinstellung ist note_symbol)
    \param    r_warning_symbol Name der Makrovariable, die den Wert für WARNING zurückgibt 
                            (Voreinstellung ist warning_symbol)
    \param    r_error_symbol Name der Makrovariable, die den Wert für ERROR zurückgibt 
                            (Voreinstellung ist error_symbol)
    \version  1.0
    \author   Andreas Mangold
    \date     10.08.2007
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
