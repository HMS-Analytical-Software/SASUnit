/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Takes a blank delimited list of paramters and checks then for empty values.

               If one has missing values or das not exist then the return is set to STOP

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
            
   \param      i_listOfParameters   Blank delimited list containing names of macrovariables
   \param      i_returnCodeVariable Name of macrovariable to receive return code

*/ /** \cond */ 
%MACRO _checkListOfParameters (i_listOfParameters     = 
                              ,i_returnCodeVariable   =
                              ,i_callingMacroName     =     
                              ,i_messageLevel         = DEBUG
                              ,i_MissingValueAllowed  = NO
                              );

      %LOCAL 
         l_parameterCounter
         l_parameterName
         l_numberOfParameters
      ;

      %let &i_returnCodeVariable. = STOP;

      %let l_numberOfParameters = %eval (%sysfunc (count (&i_listOfParameters., %str ( )))+1);

      %do l_parameterCounter = 1 %to &l_numberOfParameters.;
         %let l_parameterName = %scan (&i_listOfParameters., &l_parameterCounter., %str ( ));
         %if %_handleError(&i_callingMacroName.
                          ,NonExistentParameter
                          ,not %sysfunc (symexist (&l_parameterName.))
                          ,%str(Error in parameterizing &i_callingMacroName.: Parameter &l_parameterName. is non-existent)
                          ) 
               %THEN %GOTO exit;
         %if (%upcase(&i_MissingValueAllowed.) = NO) %then %do;
            %if %_handleError(&i_callingMacroName.
                             ,MissingParameter
                             ,"&&&l_parameterName" EQ ""
                             ,%str(Error in parameterizing &i_callingMacroName.: Parameter &l_parameterName. is missing)
                             ) 
                  %THEN %GOTO exit;
         %end;
      %end;

      %let &i_returnCodeVariable. = OK;

   %exit:

%MEND _checkListOfParameters;
/** \endcond */