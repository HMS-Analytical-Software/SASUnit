/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      determines whether a certain variable, optionally of a certain type, 
               exists in a SAS dataset

   \%_existVar (dataset, variable, type)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_data     input dataset
   \param   i_var      name of the variable
   \param   i_vartype  type of variable (N for numeric or C for character or empty for don't care)
   \return  1 ..  variable existst, 0 ... variable does not existst

*/ /** \cond */ 

%MACRO _existVar (i_data       
                 ,i_var        
                 ,i_vartype    
                 ); 

   %LOCAL dsid varnum;
   %LET dsid=%sysfunc(open(&i_data,i));
   %IF &dsid EQ 0 %THEN 0;
   %ELSE %DO;
      %LET varnum=%sysfunc(varnum(&dsid,&i_var));
      %IF &varnum LE 0 %THEN 0;
      %ELSE 
         %IF &i_vartype NE 
            AND %sysfunc(vartype(&dsid,&varnum)) NE %upcase(&i_vartype) 
            %THEN 0;
      %ELSE 1;
      %LET dsid = %sysfunc(close(&dsid));
   %END;
%MEND _existVar;
/** \endcond */
