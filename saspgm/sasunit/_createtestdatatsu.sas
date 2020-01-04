/** 
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Creates test data base table tsu.

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

   \todo    Reimplement target.tsu as name value pair. If there is a new parameter only writing this parameter needs to be implemented.   
            Using it will be automatically possible.  No need to change layout of Test-DB-TSU
   \todo    Implement macro _writeParameterToTestDBTSU
   \todo    If there is a need to have it then implement _readParameterFromTestDBTSU
*/
%macro _createTestDataTSU (libref=target);
      PROC SQL NOPRINT;
         CREATE TABLE &libref..tsu(COMPRESS=CHAR)
         (                                         /* test suite */
             tsu_project         CHAR(1000)        /* name of the project */
            ,tsu_root            CHAR(1000)        /* root folder of the project */
            ,tsu_target          CHAR(1000)        /* root folder for test documentation */
            ,tsu_sasunitroot     CHAR(1000)        /* root path to sasunit files */
            ,tsu_sasunit         CHAR(1000)        /* folder with sasunit macros (defaults to <tsu_sasunit>/saspgm/sasunit) */
            ,tsu_sasunit_os      CHAR(1000)        /* os-specific sasunit macros  (defaults to <tsu_sasunit>/saspgm/sasunit/<os>) */
            ,tsu_sasautos        CHAR(1000)        /* first autocall path */
      %DO i=1 %TO 29;            
            ,tsu_sasautos&i      CHAR(1000)        /* autocall path 2 to 30 */
      %END;                     
            ,tsu_autoexec        CHAR(1000)        /* autoexec file to be used */
            ,tsu_sascfg          CHAR(1000)        /* sas config file to be used */
            ,tsu_sasuser         CHAR(1000)        /* folder for sasuser data sets */
            ,tsu_testdata        CHAR(1000)        /* folder containing test data to work with */
            ,tsu_refdata         CHAR(1000)        /* folder containing refernce data to compare with */
            ,tsu_doc             CHAR(1000)        /* FOlder with specification documents */
            ,tsu_lastinit        INT FORMAT=datetime21.2 /* date and time of last initialization */
            ,tsu_lastrep         INT FORMAT=datetime21.2 /* date and time of last report generation*/
            ,tsu_testcoverage    INT FORMAT=8.     /* Should test coverage be used? */
            ,tsu_dbversion       CHAR(8)           /* Version String to force creation of a new test data base */
            ,tsu_verbose         INT FORMAT=8.     /* Level of messaging in SASUnit */
            ,tsu_crossref        INT FORMAT=8.     /* Cross reference for project (0/1) */
            ,tsu_crossrefsasunit INT FORMAT=8.     /* Cross reference for SASUnit (0/1) */
            ,tsu_language        CHAR(10)          /* Language for test documentation */
            ,tsu_prjbinfolder    CHAR(500)       /* project bin folder containing start scripts */
         );
         INSERT INTO &libref..tsu VALUES (
            "","","","","",""
           ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
           ,"","","","","","",.,.,.,"",.,.,.,"",""
           );
      QUIT;
   %mend _createTestDataTSU;
