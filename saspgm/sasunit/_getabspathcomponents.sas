/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief     of a given absolute file path (with / as dir separator), 
              extract the file name and the path to the file (without file name)
              Example: The absolute path C:/temp/test.sas splitted into the two strings C:/temp and test.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_absPath         full absolute path of a file
   \param   o_fileName        name of a result macro variable with the file name
   \param   o_pathWithoutName name of a result macro variable with the path without the file name

   \retval  o_pathWithoutName name of a result macro variable with the path without the file name
*/ /** \cond */ 

%MACRO _getAbsPathComponents (i_absPath =
                             ,o_fileName =
                             ,o_pathWithoutName =
                             ); 

   %LOCAL l_pathElementCount;
   %LOCAL l_fileNameStartPos;

   %LET &o_fileName=;
   %LET &o_pathWithoutName=;

   %IF "%sysfunc(compress(&i_absPath))" NE "" %THEN %DO; /*if not empty input string*/
      %IF %sysfunc(index(&i_absPath.,/)) GT 0 %THEN %DO; /*input string contains dir separators*/
         %LET l_pathElementCount=%sysfunc(countw(&i_absPath.,/));
         %LET l_fileNameStartPos=%sysfunc(findw(&i_absPath.,%scan(&i_absPath,&l_pathElementCount,/)));
         %LET &o_pathWithoutName=%sysfunc(substr(&i_absPath.,1,%EVAL(&l_fileNameStartPos. - 2)));
         %LET &o_fileName = %sysfunc(substr(&i_absPath.,&l_fileNameStartPos.));
     %END; /*IF %sysfunc(index(&i_absPath.,'/')) GT 0*/
     %ELSE %DO; /*input string is a filename only*/
        %LET &o_fileName = &i_absPath;
     %END;
   %END; /*IF "%sysfunc(compress(&i_absPath))" NE ""*/
   
%MEND _getAbsPathComponents;
/** \endcond */
