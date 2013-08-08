/** 
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      Deletes all appendant files in the log, tst and rep folders.
               Called before a scenario is being executed in order to avoid disused files

   \version    \$Revision: 216 $
   \author     \$Author: klandwich $
   \date       \$Date: 2013-07-31 09:03:21 +0200 (Mi, 31 Jul 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_deletescenariofiles.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_scnid  All files of this scenario are to be deleteded

*/ /** \cond */  

%MACRO _deletescenariofiles(i_scnid =
                            );

   %LOCAL l_nobs l_target;
   
   %LET l_target = %_abspath(&g_root, &g_target);
 
   %*** Deletion of /rep files *;
   %_dir(i_path=&l_target./rep/%str(*.*), o_out=dir1);
   DATA test;
      FILE "%sysfunc(pathname(work))/_scenarioFilesToDelete.sas";
      SET dir1;
      IF prxmatch("/rep\/&i_scnid..*$/", filename) OR 
         prxmatch("/rep\/_&i_scnid._.*$/", filename) OR 
         prxmatch("/rep\/cas_&i_scnid._.*$/", filename) THEN DO;
         PUT '%PUT Delete ' filename ' RC: %_delfile(' filename ');';
         putlog '%PUT Delete ' filename ' RC: %_delfile(' filename ');';
      END;
   RUN;

   %*** Deletion of /log files ***;
   %_dir(i_path=&l_target./log/&i_scnid.%str(*), o_out=dir2);
   DATA _NULL_;
      FILE "%sysfunc(pathname(work))/_scenarioFilesToDelete.sas" mod;
      SET dir2;
      %***IF (filename =: "&l_target./log/&i_scnid.") THEN DO ****;
      IF prxmatch("/\/&i_scnid..*$/", filename) THEN DO; 
         PUT '%LET rc=%_delfile(' filename ');' ;
         putlog '%LET rc=%_delfile(' filename ');';
      END;
   RUN;  
   
   %*** Deletion of /tst files ***;
   %_dir(i_path=&l_target./tst/&i_scnid.%str(*), o_out=dir3);
   DATA _NULL_;
      FILE "%sysfunc(pathname(work))/_scenarioFilesToDelete.sas" mod;
      SET dir3;
      %*** IF (filename =: &l_target./tst/&i_scnid.) THEN DO; ****;
      IF prxmatch("/\/&i_scnid..*$/", filename) THEN DO;
         PUT '%LET rc=%_delfile(' filename ');';
         putlog '%LET rc=%_delfile(' filename ');';
      END;
   RUN;

   %include "%sysfunc(pathname(work))/_scenarioFilesToDelete.sas";
   
   %*** Deletion of /tst folders ***;
   PROC SQL;
     CREATE TABLE foldersToDelete AS
     SELECT distinct tst_scnid, tst_casid, tst_id, tst_type
     FROM target.tst
     WHERE tst_scnid = &i_scnid.;
     ;
   QUIT;
   
   %LET l_nobs = &SYSNOBS;
   %*** Write and execute cmd file only if table foldersToDelete is not empty ***;
   %IF &l_nobs > 0 %THEN %DO;
      %_oscmds;
      DATA _NULL_;
         FILE "%sysfunc(pathname(work))/_scenarioFoldersToDelete.cmd";
         SET foldersToDelete;
         PUT "&g_removedir ""&l_target.\tst\_" tst_scnid +(-1)"_" tst_casid +(-1)"_" tst_id +(-1) "_" tst_type +(-1)"""&g_endcommand";
         PUTLOG "&g_removedir ""&l_target.\tst\_" tst_scnid +(-1)"_" tst_casid +(-1)"_" tst_id +(-1) "_" tst_type +(-1)"""&g_endcommand";
      RUN;
      %_xcmd("%sysfunc(pathname(work))/_scenarioFoldersToDelete.cmd");      
   %END;

%MEND _deletescenariofiles;
/** \endcond */



