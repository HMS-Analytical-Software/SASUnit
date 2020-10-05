/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief     get file extension including the separating dot

   \%_getExtension(file name)

              Example: %_getExtension(test.sas) yields .sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_file     file name with extension
   \return  file name extension or empty if file name does not contain a dot

*/ /** \cond */ 
%MACRO _getExtension (i_file  
                     ); 

   %LOCAL i; %LET i=0;
   %DO %WHILE("%scan(&i_file,%eval(&i+1),.)" NE "");
      %LET i=%eval(&i+1);
   %END;
   %IF &i>1 %THEN .%scan(&i_file,&i,.);

%MEND _getExtension;
/** \endcond */
