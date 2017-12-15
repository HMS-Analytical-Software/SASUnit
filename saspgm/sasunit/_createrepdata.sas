/** 
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Creates reporting dataset.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   d_reporting Name of dataset to be created

*/ /** \cond */ 

%macro _createRepData (d_reporting=);
   /*-- generate temporary datasets ---------------------------------------------*/
   %LOCAL 
      d_scn 
      d_pgm 
      d_emptyscn 
      d_cas
      d_tst
      d_exa
      l_macname
   ;

   %LET l_macname=&sysmacroname;

   %_tempFilename(d_scn)
   %_tempFilename(d_pgm)
   %_tempFilename(d_emptyscn)
   %_tempFilename(d_cas)
   %_tempFilename(d_tst)
   %_tempFilename(d_exa)


   /*-- check for empty scenarios and generate entries in temporary copies of cas and tst datasets,
        in order to make scenario appear in report with a dummy test case --------------------------- */
   %LOCAL
      l_sEmptyScnDummyCasDesc
   ;
   %LET l_sEmptyScnDummyCasDesc = %STR(no valid test case found - must be red!);

   PROC SQL NOPRINT;
      CREATE TABLE &d_emptyscn. AS
         SELECT
            t1.scn_id
            FROM target.scn t1
            WHERE t1.scn_id NOT IN
            (
               SELECT
                  Distinct cas_scnid
                  FROM target.cas
            )
      ;
   QUIT;

   PROC SQL NOPRINT;
      CREATE TABLE &d_cas. AS
         SELECT
           t1.*
          FROM target.cas t1
      ;
      INSERT INTO &d_cas.
      (
         cas_scnid
        ,cas_id
        ,cas_obj
        ,cas_desc
        ,cas_spec
        ,cas_start
        ,cas_end
        ,cas_res
      )
      (
         SELECT
             scn_id
            ,1
            ,'^_'
            ,"&l_sEmptyScnDummyCasDesc."
            ,'^_'
            ,.
            ,.
            ,2
            FROM &d_emptyscn.
      )
      ;
   QUIT;

   PROC SQL NOPRINT;
     CREATE TABLE &d_tst. AS
       SELECT
         t1.*
         FROM target.tst t1
     ;
     INSERT INTO &d_tst.
     (
       tst_scnid
      ,tst_casid
      ,tst_id
      ,tst_type
      ,tst_desc
      ,tst_exp
      ,tst_act
      ,tst_res
      ,tst_errmsg
     )
     (
       SELECT
          scn_id
         ,1
         ,0
         ,'^_'
         ,'^_'
         ,'^_'
         ,'^_'
         ,2
         ,''
         FROM &d_emptyscn.
     )
     ;  
   QUIT;

   PROC SQL NOPRINT;
     CREATE TABLE &d_exa. AS
       SELECT
         t1.*
         FROM target.exa t1
     ;
     INSERT INTO &d_exa.
     (
          exa_id
         ,exa_auton
         ,exa_pgm
         ,exa_changed
         ,exa_filename
         ,exa_path
         ,exa_tcg_pct
     )
     VALUES(
          .
         ,.
         ,''
         ,.
         ,''
         ,''
         ,.
     )
     ;  
   QUIT;


   /*-- determine return code per examinee ---------------------------------------*/
   PROC SQL NOPRINT;
      create table &d_pgm. as
         select max (cas_res) as exa_res
                ,cas_exaid as pgm_exaid
         from &d_cas.
         group by cas_exaid;
   QUIT;

   /*-- create reporting dataset ------------------------------------------------*/
   %LOCAL i;

PROC SQL NOPRINT;
      CREATE TABLE &d_reporting. (COMPRESS=YES) AS
      SELECT 
          tsu_project    
         ,tsu_root       
         ,tsu_target       
         ,tsu_sasunit    
         ,tsu_sasunit_os
         ,tsu_sasautos   
         ,tsu_sasautos as tsu_sasautos0
   %DO i=1 %TO 29;
         ,tsu_sasautos&i 
   %END;
         ,tsu_autoexec   
         ,tsu_sascfg     
         ,tsu_sasuser    
         ,tsu_testdata   
         ,tsu_refdata    
         ,tsu_doc        
         ,tsu_lastinit
         ,tsu_lastrep
         ,tsu_dbversion
         ,scn_id     
         ,scn_path   
         ,scn_desc   
         ,scn_start  
         ,scn_end    
         ,scn_rc     
         ,scn_res 
         ,scn_errorcount
         ,scn_warningcount 
         ,cas_id    
         ,exa_id
         ,exa_auton
         ,exa_pgm
         ,exa_filename
         ,exa_path
         ,exa_res
         ,cas_obj  
         ,cas_desc  
         ,cas_spec  
         ,cas_start 
         ,cas_end   
         ,cas_res 
         ,tst_id
         ,tst_type
         ,tst_desc
         ,tst_exp
         ,tst_act
         ,tst_res
         ,tst_errmsg
      FROM 
          target.tsu
         ,target.scn
         ,&d_cas.
         ,&d_tst.
         ,&d_exa.
         ,&d_pgm.
      WHERE 
         scn_id       = cas_scnid AND         
         scn_id       = tst_scnid AND
         cas_id       = tst_casid AND
         cas_exaid    = exa_id    AND
         exa_id       = pgm_exaid
      ORDER BY scn_id, cas_id, tst_id;
   QUIT;

   PROC SQL NOPRINT;
      CREATE UNIQUE INDEX idx1 ON &d_reporting. (scn_id, cas_id, tst_id);
      CREATE UNIQUE INDEX idx2 ON &d_reporting. (exa_auton, exa_id, scn_id, cas_id, tst_id);
   QUIT;

   %IF %_handleError(&l_macname.
                    ,ErrorTestDB
                    ,&syserr. NE 0
                    ,%nrstr(Fehler beim Zugriff auf die Testdatenbank)
                    ,i_verbose=&g_verbose.
                    )
      %THEN %GOTO errexit;
   %GOTO exit;

%errexit:
   PROC DATASETS NOWARN NOLIST LIB=work;
      DELETE %scan(&d_reporting,2,.);
   QUIT;

%exit:
   PROC DATASETS NOWARN NOLIST LIB=work;
      DELETE %scan(&d_pgm.,2,.)
             ;
   QUIT;
%mend _createRepData;
/** \endcond */
