/** 
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Creates test data base table exa.

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
            
   \param   libref Library for the test database (optionaL: Default=target)

*//** \cond */
%macro _createTestDataEXA (libref=target);
   PROC SQL NOPRINT;
      CREATE TABLE &libref..exa(COMPRESS=CHAR)
      (                                        /* all possible examinees */
          exa_id       INT FORMAT=z3.          /* number of examinees */
         ,exa_auton    INT                     /* Number of autocall path */
         ,exa_pgm      CHAR(1000)              /* name of program file */ 
         ,exa_changed  INT FORMAT=datetime21.2 /* Change Datetime value of examinee */
         ,exa_filename CHAR(1000)              /* absolute path and name of program file */
         ,exa_path     CHAR(1000)              /* path of program file relative to SASUnit Root */ 
         ,exa_tcg_pct  INT FORMAT=NLPCT.     
      );
   QUIT;
%mend _createTestDataEXA;
/** \endcond */