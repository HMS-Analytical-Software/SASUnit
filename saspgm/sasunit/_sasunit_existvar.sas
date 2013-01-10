/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      determines whether a certain variable, optionally of a certain type, 
               exists in a SAS dataset

   \%existVar (dataset, variable, type)

   \param   i_data     input dataset
   \param   i_var      name of the variable
   \param   i_vartype  type of variable (N for numeric or C for character or empty for don't care)
   \return  1 ..  variable existst, 0 ... variable does not existst

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%MACRO _sasunit_existVar (
   i_data       
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
%MEND _sasunit_existVar;
/** \endcond */
