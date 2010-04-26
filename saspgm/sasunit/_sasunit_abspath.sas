/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      prüft, ob ein übergebener Pfad absolut oder leer ist. Wenn nicht, wird 
               er mit dem Rootpfad verkettet

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007

   \param   i_root   optional: Rootpfad
   \param   i_path   zu prüfender Pfad

   \return           gibt den geänderten Pfad zurück
*/ /** \cond */ 

%MACRO _sasunit_abspath (
    i_root
   ,i_path 
);

%IF "&i_path" EQ "" %THEN %RETURN;

%IF %length(&i_root) %THEN %DO;
   %LET i_root = %qsysfunc(translate(&i_root,/,\));
   %IF "%substr(&i_root,%length(&i_root),1)" = "/" %THEN 
      %LET i_root=%substr(&i_root,1,%eval(%length(&i_root)-1));
%END;

%LET i_path = %qsysfunc(translate(&i_path,/,\));
%IF "%substr(&i_path,1,1)" = "/" OR "%substr(&i_path,2,2)" = ":/" %THEN &i_path;
%ELSE %IF %length(&i_root) %THEN &i_root/&i_path;
%ELSE &i_path;

%MEND _sasunit_abspath;
/** \endcond */
