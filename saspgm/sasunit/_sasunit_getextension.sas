/** \file
   \ingroup    SASUNIT_UTIL 

   \brief     Dateinamenerweiterung einschließlich Punkt ermitteln 

   \%getExtension(dateiname)

              Beispiel: %getExtension(test.sas) ergibt .sas

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_file     Dateiname mit Dateinamenerweiterung
   \return  letzter Namensbestandteil ab einem Punkt, leer, wenn kein Punkt enthalten
*/ /** \cond */ 

%MACRO _sasunit_getExtension (
    i_file  
); 

%LOCAL i; %LET i=0;
%DO %WHILE("%scan(&i_file,%eval(&i+1),.)" NE "");
   %LET i=%eval(&i+1);
%END;
%IF &i>1 %THEN .%scan(&i_file,&i,.);

%MEND _sasunit_getExtension;
/** \endcond */
