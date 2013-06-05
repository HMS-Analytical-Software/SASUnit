/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      standardizes a path makes it relative to a root path

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_root       root path
   \param   i_path       path to be standardized
   \return  standardized path
*/ /** \cond */ 

%MACRO _stdPath(
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
%MEND _stdPath;
/** \endcond */
/*
%put %_stdPath(c:\temp,c:\temp\test\sas.log);
%put %_stdPath(c:\temp,c:\temp\test\);
%put %_stdPath(c:\temp,c:\temp\test);
%put %_stdPath(c:\temp,c:\temp\);
%put %_stdPath(c:\temp,c:\temp);
%put %_stdPath(c:\temp,c:\tempo);
%put %_stdPath(c:\temp,d:\temp);
*/