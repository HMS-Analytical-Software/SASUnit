/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Reads a name value pair from testdb (target) tsu

   \version    \$Revision: 688 $
   \author     \$Author: klandwich $
   \date       \$Date: 2019-07-05 10:44:12 +0200 (Fr, 05 Jul 2019) $
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_checkscenario.sas $
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      i_parameterName   Name of parameter to be inserted/updated in test db (tsu)
   \param      o_parameterValue  Name of variable to receive value read from test db (tsu)
   \param      o_parameterScope  Scope of Parameter (G, L, or _AUTOMATIC_)
   \param      i_Libref          Libref pointing to test  db (optional: Default=target)
   \param      i_silent          Turn WARNING into INFO if set to 1 (0/1) (optional: Default=0)

*/ /** \cond */ 

%MACRO _readParameterFromTestDBtsu (i_parameterName  = 
                                   ,o_parameterValue =
                                   ,i_libref         = target
                                   ,o_defaultValue   = _NONE_
                                   ,i_silent         = 0
                                   );
      %local
         l_nameFound
         l_parameterName
         l_parameterValue
      ;

      %let l_nameFound      = 0;
      %let l_parameterName  = %upcase (&i_parameterName.);
      %let l_parameterValue = _NONE_;
      
      data _NULL_;
         set &i_libref..tsu (where=(upcase (tsu_parameterName) = "&l_parameterName."));
         call symputx ("l_parameterValue", tsu_parameterValue, "L");
      run;

      %put _LOCAL_;
         
      %if (%quote(&l_parameterValue.) = _NONE_) %then %do;
         %if (&i_silent.) %then %do;
            %_issueInfoMessage (&g_currentLogger., Parameter &i_parametername was not found!);
         %end;
         %else %do;
            %_issueWarningMessage (&g_currentLogger., Parameter &i_parametername was not found!);
         %end;
         %let l_parameterValue = &o_defaultValue.;
      %end;

   %exit:
      %let &o_parameterValue. = &l_parameterValue.;

%MEND _readParameterFromTestDBtsu;
/** \endcond */
