/** 
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Creates test data base table tst.

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
%macro _createTestDataTST (libref=target);
      PROC SQL NOPRINT;
         CREATE TABLE &libref..tst(COMPRESS=CHAR)
         (                                    /* Test */
             tst_scnid  INT FORMAT=z3.        /* reference to test scenario */
            ,tst_casid  INT FORMAT=z3.        /* reference to test case */
            ,tst_id     INT FORMAT=z3.        /* sequential number of test within test case */
            ,tst_type   CHAR(32)              /* type of test (name of assert macro) */
            ,tst_desc   CHAR(1000)            /* description of test */
            ,tst_exp    CHAR(255)             /* expected result */
            ,tst_act    CHAR(255)             /* actual result */
            ,tst_res    INT                   /* test result of the last run: 0 .. OK, 1 .. manual, 2 .. not OK */
            ,tst_errmsg CHAR(1000)            /* custom error message for asserts */
         );
      QUIT;
%mend _createTestDataTST;
/** \endcond */