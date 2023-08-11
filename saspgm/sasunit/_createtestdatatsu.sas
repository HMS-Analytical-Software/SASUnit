/** 
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Creates test data base table tsu.

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
            
   \param   libref Library for the test database (optional: Default=target)

*//** \cond */
%macro _createTestDataTSU (libref=target);
   PROC SQL NOPRINT;
      CREATE TABLE &libref..tsu(COMPRESS=CHAR)
      (                                         /* test suite */
          tsu_parameterName   CHAR(50)          /* name of the parameter */             
         ,tsu_parameterValue  CHAR(1000)        /* value of zhe parameter */
         ,tsu_parameterScope  CHAR(1)           /* scope of parameter ('G' / 'L') */
      );
   QUIT;
%mend _createTestDataTSU;
/** \endcond */