/** 
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      Deletes all appendant files in the log, tst and rep folders.
               Called before a scenario is being executed in order to avoid disused files

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \remark     still uses _dir for deletion of a tree. This macro is called by runSASUnit. runSASUnit will not be called interactively. 
               So there is no need to change anything with this macro concerning NOXCMD

   \param      i_scenariosToRun  Data set containing all scenarios that have to run

*/ /** \cond */  



%MACRO _deletescenariofiles(i_scenariosToRun=
                           );
   %LOCAL l_len l_nobs l_obs l_scnDel l_target l_foldersToDelete l_filesToDelete;
   %LET l_target = %_abspath(&g_root, &g_target);
   
   PROC SQL NOPRINT;
      CREATE TABLE scenarioFilesToDelete AS
      SELECT scn_id
      FROM &i_scenariosToRun AS s
      WHERE s.dorun = 1 AND scn_id IN (SELECT scn_id FROM target.scn)
      ;
      SELECT scn_id into :l_scnDel separated by ','
      FROM scenarioFilesToDelete
      ;
      SELECT count(scn_id) AS cnt into :l_obs
      FROM scenarioFilesToDelete
      ;
   QUIT;

   %IF &l_obs GT 0 %THEN %DO;
      %*** Dir for deletion of /rep, /tst and /log files *;
      %_dir(i_path=&l_target./rep/, o_out=rep);
      %_dir(i_path=&l_target./log/, o_out=log);
      %_dir(i_path=&l_target./tst/, o_out=tst);

      %let l_filesToDelete = %sysfunc(pathname(work))/_scenarioFilesToDelete.sas;
      DATA _NULL_;
         FILE "&l_filesToDelete";
         SET scenarioFilesToDelete nobs=numobs_dorun;

         DO i=1 TO numobs_log;
            SET log nobs=numobs_log point=i;
            IF index(membername, put(scn_id,z3.)) = 1 THEN DO;
               PUT '%PUT Delete ' filename ' RC: %_delfile(' filename ');';
            END;
         END;
         DO j=1 TO numobs_rep;
            SET rep nobs=numobs_rep point=j;
            IF index(membername, put(scn_id,z3.)) = 1 OR
               index(membername, catt("_", put(scn_id,z3.))) = 1 OR
               index(membername, catt("cas_", put(scn_id,z3.),"_")) = 1 OR
               index(membername, catt("tcg_", put(scn_id,z3.))) = 1
            THEN DO;
               PUT '%PUT Delete ' filename ' RC: %_delfile(' filename ');';
            END;
         END;
         DO k=1 TO numobs_tst;
            SET tst nobs=numobs_tst point=k;
            IF index(membername, put(scn_id,z3.)) = 1 THEN DO;
               PUT '%PUT Delete ' filename ' RC: %_delfile(' filename ');';
            END;
         END;
      RUN;
      %INCLUDE "&l_filesToDelete.";
      %LET l_rc=%_delfile(&l_filesToDelete.);

      %*** Deletion of /tst folders ***;
      %_dir(i_path=&l_target./tst/, i_recursive=1, o_out=tst_folder);
      
      %LET l_len = %sysfunc(length(&l_target./tst/));

      DATA foldersToDelete;
         SET tst_folder;
         part = substr(filename, &l_len+1);
         pos  = index(part, "/");
         IF pos > 0 THEN DO;
            folder = substr(part, 1, pos-1);
            id = input(substr(folder,2,3),3.);
            IF id IN (&l_scnDel) THEN DO;
               OUTPUT;
            END;
         END;
         KEEP id folder;
      RUN;
      
      %LET l_nobs = %_nobs(foldersToDelete);
      
      %*** Write and execute cmd file only if table foldersToDelete is not empty ***;
      %IF &l_nobs > 0 %THEN %DO;
         PROC SORT DATA = foldersToDelete nodupkey;
            BY folder;
         RUN;
      
         %let l_foldersToDelete = %sysfunc(pathname(work))/_scenarioFoldersToDelete.cmd;
         DATA _NULL_;
            FILE "&l_foldersToDelete";
            SET foldersToDelete;
            PUT "&g_removedir ""&l_target./tst/" folder+(-1)"""&g_endcommand";
         RUN;
         %_executeCMDFile(&l_foldersToDelete);
         %LET l_rc=%_delfile(&l_foldersToDelete);
      %END;
   %END;
%MEND _deletescenariofiles;
/** \endcond */
