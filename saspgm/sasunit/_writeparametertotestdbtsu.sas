/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Writes a name value pair to testdb (target) tsu

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      i_parameterName   Name of parameter to be inserted/updated in test db (tsu)
   \param      i_parameterValue  Value to be set / updated in test db tsu
   \param      i_parameterScope  Scope of Parameter (G or L) (optional: Deafult=G)
   \param      i_Libref          Libref pointing to test db (optional: Default=target)

*/ /** \cond */ 
%MACRO _writeParameterToTestDBtsu (i_parameterName  = 
                                  ,i_parameterValue =
                                  ,i_parameterScope =G
                                  ,i_libref         =target
                                  );
      %local
         l_nameFound
         l_parameterName
         l_parameterScope
      ;

      %let l_nameFound      = 0;
      %let l_parameterName  = %upcase (&i_parameterName.);
      %let l_parameterScope = %upcase (&i_parameterScope.);
      %if (&l_parameterScope. ne G) %then %do;
         %let l_parameterScope = L;
      %end;

      %if (%length(&i_parameterValue.) = 0) %then %do;
         %let i_parameterValue = %str ( );
      %end;
      proc sql noprint;
         select count (tsu_parameterName) into :l_nameFound 
                from &i_libref..tsu 
                where upcase (tsu_parameterName) = "&l_parameterName.";
         %if (&l_nameFound.) %then %do;
            update &i_libref..tsu 
                set tsu_parameterValue=%sysfunc (quote (&i_parameterValue.)), tsu_parameterScope="&l_parameterScope."
                where upcase (tsu_parameterName) = "&l_parameterName.";
         %end;
         %else %do;
            %if (%length(&i_parameterValue.) = 0) %then %do;
               insert into &i_libref..tsu 
                  VALUES ("&l_parameterName.", "", "&l_parameterScope.");
            %end;
            %else %do;
               insert into &i_libref..tsu 
                  VALUES ("&l_parameterName.", %sysfunc (quote (&i_parameterValue.)), "&l_parameterScope.");
            %end;
         %end;
      quit;

   %exit:

%MEND _writeParameterToTestDBtsu;
/** \endcond */