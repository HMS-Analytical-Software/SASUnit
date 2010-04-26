/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      ermittelt, ob eine bestimmte Variable, optional mit einem bestimmten 
          Typ, in einer SAS-Datei existiert.

   \%existVar (datei, variable, typ)

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_data     Eingabedatei
   \param   i_var      Name der Variablen
   \param   i_vartype  Typ der Variablen (N oder C oder leer für egal)
   \return  1 ..  Variable existiert, 0 ... existiert nicht
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
