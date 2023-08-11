/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      delete an external file if it exists

   \%let rc = \%delfile (file)

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
			   
   \param      i_file   full path and name of external file
   
   \return     0 if OK, system code otherwise  
               
*/ /** \cond */ 
%MACRO _delFile(i_file   
               );

   %LOCAL rc filrf;
   %LET filrf=_tmpf;
   %LET rc=%sysfunc(filename(filrf,&i_file));
   %LET rc=%sysfunc(fdelete(_tmpf));
   &rc
   %LET rc=%sysfunc(filename(filrf));
%MEND _delFile;
/** \endcond */
