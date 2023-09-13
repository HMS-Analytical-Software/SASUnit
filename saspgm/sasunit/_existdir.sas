/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      check whether a directory exists 

   \%_existDir(directory)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
			   
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
