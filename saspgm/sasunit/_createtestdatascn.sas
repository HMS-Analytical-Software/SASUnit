/** 
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Creates test data base table scn.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   libref Library for the test database (optional: Default=target)

*//** \cond */
%macro _createTestDataSCN (libref=target);
   PROC SQL NOPRINT;
      CREATE TABLE &libref..scn(COMPRESS=CHAR)
      (                                            /* test scenario */
          scn_id           INT FORMAT=z3.          /* number of scenario */
         ,scn_path         CHAR(1000)              /* path to program file */ 
         ,scn_desc         CHAR(1000)              /* description of program (brief tag in comment header) */
         ,scn_start        INT FORMAT=datetime21.2 /* starting date and time of the last run */
         ,scn_end          INT FORMAT=datetime21.2 /* ending date and time of the last run */
         ,scn_changed      INT FORMAT=datetime21.2 /* modification date and time of the last run */
         ,scn_rc           INT                     /* return code of SAS session of last run */
         ,scn_errorcount   INT                     /* number of detected errors in the scenario log */
         ,scn_warningcount INT                     /* number of detected warnings in the scenario log */
         ,scn_res          INT                     /* overall test result of last run: 0 .. OK, 1 .. not OK, 2 .. manual */
      );
   QUIT;
%mend _createTestDataSCN;
/** \endcond */