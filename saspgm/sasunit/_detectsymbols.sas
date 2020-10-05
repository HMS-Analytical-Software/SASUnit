/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      determine the language-dependent symbols used for NOTE, ERROR, WARNING in the SAS log
               Only SAS 9.2 had language-dependent symbols. Since SAS 9.2 is no longer supported this macro simply sets the values.
               
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

   %LET &r_error_symbol.   = ERROR;
   %LET &r_warning_symbol. = WARNING;
   %LET &r_note_symbol.    = NOTE;

%MEND _detectSymbols;
/** \endcond */
