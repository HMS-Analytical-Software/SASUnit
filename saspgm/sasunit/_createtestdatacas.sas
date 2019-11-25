/** 
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Creates test data base table cas.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   libref Library for the test database (optionaL: Default=target)

*/
%macro _createTestDataCAS (libref=target);
      PROC SQL NOPRINT;
         CREATE TABLE &libref..cas(COMPRESS=CHAR)
         (                                      /* test case */
             cas_scnid INT FORMAT=z3.           /* reference to test scenario */
            ,cas_id    INT FORMAT=z3.           /* sequential number of test case within test scenario */
            ,cas_exaid INT FORMAT=z3.           /* reference to examinee */ 
            ,cas_obj   CHAR(255)                /* file name of program under test: only name if found in autocall paths, or fully qualified path otherwise */ 
            ,cas_desc  CHAR(1000)               /* description of test case */
            ,cas_spec  CHAR(1000)               /* optional: specification document, fully qualified path or only filename to be found in folder &g_doc */
            ,cas_start INT FORMAT=datetime21.2  /* starting date and time of the last run */
            ,cas_end   INT FORMAT=datetime21.2  /* ending date and time of the last run */
            ,cas_res   INT                      /* overall test result of last run: 0 .. OK, 1 .. not OK, 2 .. manual */
         );
      QUIT;
%mend _createTestDataCAS;
