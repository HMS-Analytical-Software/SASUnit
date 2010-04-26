/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      standardisiert einen Pfad und macht ihn relativ zu einem Rootpfad

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_root       Rootpfad
   \param   i_path       Name der Makrovariable mit dem zu standardisierenden Pfad
   \return  standardisierter Pfad 
*/ /** \cond */ 

%MACRO _sasunit_stdPath(
    i_root
   ,i_path
);
%LET i_root = %sysfunc(translate(&i_root,/,\));
%IF "%substr(&i_root,%length(&i_root),1)" NE "/"
   %THEN %LET i_root = &i_root/;
%LET i_path = %sysfunc(translate(&i_path,/,\));
%IF "%substr(&i_path,%length(&i_path),1)" EQ "/"
   %THEN %LET i_path = %substr(&i_path,1,%eval(%length(&i_path)-1));

%IF %index(%upcase(&i_path)/, %upcase(&i_root)) %THEN %DO;
   %IF %length (&i_path) > %length(&i_root) %THEN %DO;
      %substr(&i_path,%eval(%length(&i_root)+1))
   %END;
%END;
%ELSE %DO;
      &i_path
%END;
%MEND _sasunit_stdPath;
/** \endcond */
/*
%put %_sasunit_stdPath(c:\temp,c:\temp\test\sas.log);
%put %_sasunit_stdPath(c:\temp,c:\temp\test\);
%put %_sasunit_stdPath(c:\temp,c:\temp\test);
%put %_sasunit_stdPath(c:\temp,c:\temp\);
%put %_sasunit_stdPath(c:\temp,c:\temp);
%put %_sasunit_stdPath(c:\temp,c:\tempo);
%put %_sasunit_stdPath(c:\temp,d:\temp);
*/
