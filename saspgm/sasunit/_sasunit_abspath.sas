/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      check whether &i_path is absolute or empty. If not, append to &i_root.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
   \param   i_root   optional: root path
   \param   i_path   path to be checked

   \return           modified path
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
