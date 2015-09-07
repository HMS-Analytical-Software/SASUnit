/** \file
   \ingroup    SASUNIT_UTIL

   \brief      check for errors and set status code and messages

               If the condition i_condition is true, a message is being issued to the SAS log
               and the following three macro symbols are assigned:
               - g_error_code ... value of i_errorcode (error code)
               - g_error_msg ... value of i_text (error message)
               - g_error_macro ... value of i_macroname (calling macro program)

               The calling program should determine the name of the macro program currently running 
               with the following line of code at the top of the program: 
               \%LOCAL l_macname; \%LET l_macname = &sysmacroname ;
               Do not use &sysmacroname as the value of macro parameter g_error_macro directly , 
               because otherwise it will have a value of "handleError".

               If i_verbose has value 1, a message is being written to the SAS log 
               even when i_errorcode is not a true condition.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_macroname      name of macro where error condition occured
   \param   i_errorcode      error code unique to the calling macro
   \param   i_condition      condition - logical expression, will be evaluated and returned by the macro
   \param   i_text           error message, further information will be issued to the SAS log
   \param   i_verbose        issue message to the SAS log even if i_condition evaluates to false, 
                             default is 0
   \return                   evaluated i_condition
*/ /** \cond */

%MACRO _handleError (i_macroname      
                    ,i_errorcode      
                    ,i_condition      
                    ,i_text           
                    ,i_verbose=0       
                    );

%IF %unquote(&i_condition) %THEN %DO;
   1
   %PUT;
   %PUT --------------------------------------------------------------------------------;
   %PUT ERROR(SASUNIT) &i_errorcode in Makro &i_macroname (Condition: &i_condition);
   %IF "&i_text" NE ""
      %THEN %PUT &i_text;
   %PUT --------------------------------------------------------------------------------;
   %PUT;
   %LET g_error_code = &i_errorcode;
   %LET g_error_msg  = &i_text;
   %LET g_error_macro= &i_macroname;
%END;
%ELSE %DO;
   0
   %IF &i_verbose %THEN %DO;
      %PUT;
      %PUT handleError: OK: &i_errorcode &i_macroname (Condition: &i_condition);
      %PUT;
   %END;
%END;
%MEND _handleError;
 /** \endcond */
