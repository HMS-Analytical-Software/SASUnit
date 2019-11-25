/** 
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Creates test data base table exa.

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
