/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      check whether a directory exists 

   \%_existDir(directory)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_dir     complete path to directory to be checked
   \return  1 .. directory exists, 0 .. directory does not exists

*/ /** \cond */ 

%MACRO _existDir(i_dir
                );
   %LOCAL rc did filrf;
   %LET filrf=_tmpf;
   %LET rc=%sysfunc(filename(filrf,&i_dir));
   %LET did=%sysfunc(dopen(_tmpf));
   /* directory opened successfully */
   %IF &did NE 0 %THEN %DO;
      1
      %LET rc=%sysfunc(dclose(&did));
   %END;
   /* directory could not be opened */
   %ELSE %DO;
      0
   %END;
   %LET rc=%sysfunc(filename(filrf));
%MEND _existDir;
/** \endcond */
