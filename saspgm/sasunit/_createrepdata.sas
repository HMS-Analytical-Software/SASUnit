/** 
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Creates reporting dataset.

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
            
   \param   d_reporting Name of dataset to be created
*/ /** \cond */ 
%macro _createRepData (d_reporting    =
                      ,d_repexa       =
                      );
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
   %LOCAL i l_lastrep;
   *** Check if all entries are present ***;
   %_readParameterFromTestDBtsu (i_parameterName  =tsu_lastrep
                                ,o_parameterValue =l_lastrep
                                ,i_silent         =1
                                );

   %if (&l_lastrep. = _NONE_) %then %do;
       %_writeParameterToTestDBtsu (i_parameterName  =tsu_lastrep        
                                   ,i_parameterValue =0
                                   );
   %end;
   
   PROC TRANSPOSE data=target.tsu out=work._tsu;
      id tsu_parameterName;
      var tsu_parameterValue;
   RUN;
   
   DATA work._tsu;
      set work._tsu (rename=(tsu_lastinit=char_lastinit tsu_lastrep=char_lastrep));
      tsu_lastinit = input (char_lastinit, best32.);
      tsu_lastrep  = input (char_lastrep,  best32.);
      drop char_: _NAME_;
   RUN;

   PROC SQL NOPRINT;
      CREATE TABLE &d_reporting. (COMPRESS=YES) AS
      SELECT 
          tsu_project    
         ,tsu_root       
         ,tsu_target       
         ,tsu_sasunit    
         ,tsu_sasunit_os
         ,tsu_sasautos   
   %DO i=0 %TO 29;
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
         ,tsu_logFolder
         ,tsu_scnLogFolder
         ,tsu_log4SASSuiteLogLevel
         ,tsu_log4SASScenarioLogLevel
         ,tsu_reportFolder
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
          work._tsu
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

   proc sql noprint;
      create table &d_repexa. as 
         select distinct exa.*
                ,_tsu.*
                ,cas.cas_obj
         from target.exa left join target.cas
              on exa.exa_id=cas.cas_exaid
              ,work._tsu
         order by exa_auton, exa_id;
   quit;
   
   %IF %_handleError(&l_macname.
                    ,ErrorTestDB
                    ,&syserr. NE 0
                    ,%nrstr(Fehler beim Zugriff auf die Testdatenbank)
                    )
      %THEN %GOTO errexit;
   %GOTO exit;

%errexit:
   PROC DATASETS NOWARN NOLIST LIB=work;
      DELETE %scan(&d_reporting,2,.);
   QUIT;

%exit:
   PROC DATASETS NOWARN NOLIST LIB=work;
      DELETE 
        %scan(&d_pgm.,2,.)
        %scan(&d_scn.,2,.)
        %scan(&d_emptyscn.,2,.)
        %scan(&d_cas.,2,.)
        %scan(&d_tst.,2,.)
        %scan(&d_exa.,2,.)
        _tsu
             ;
   QUIT;
%mend _createRepData;
/** \endcond */