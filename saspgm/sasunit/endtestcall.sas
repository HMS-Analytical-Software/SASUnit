/**
   \file
   \ingroup    SASUNIT_SCN 

   \brief      Ends an invocation of a program under test

               internally:
               - Ensure sequence
               - End redirection of SAS log
               - Reset ODS destinations

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
               
*/ /** \cond */ 

%MACRO endTestcall();

   %GLOBAL g_inTestcase;
   %IF &g_inTestcase NE 1 %THEN %DO;
      %PUT &g_error.(SASUNIT): endTestcall muss nach InitTestcase aufgerufen werden;
      %RETURN;
   %END;
   %LET g_inTestcase=2;

   %LOCAL l_casid l_filled l_lstfile; 

   /* restore log and listing of test scenario */
   %LET g_logfile  =&g_log/%substr(00&g_scnid,%length(&g_scnid)).log;
   %LET g_printfile=&&g_testout/%substr(00&g_scnid,%length(&g_scnid)).lst;

   PROC PRINTTO 
      LOG="&g_logfile."
      PRINT="&g_printfile."
   ;
   RUN;

   /* determine and store end time */
   PROC SQL NOPRINT;
      SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
   %LET l_casid = &l_casid;
   PROC SQL NOPRINT;
      UPDATE target.cas
      SET 
         cas_end = %sysfunc(datetime())
      WHERE 
         cas_scnid = &g_scnid AND
         cas_id    = &l_casid;
   QUIT;

   /* delete listing if empty */
   PROC SQL NOPRINT;
      SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
   QUIT;
   %LET l_casid = &l_casid;
   %LET l_filled=0;
   %LET l_lstfile=&g_testout/%substr(00&g_scnid,%length(&g_scnid))_%substr(00&l_casid,%length(&l_casid)).lst;
   DATA _null_;
      INFILE "&l_lstfile";
      INPUT;
      CALL symput ('l_filled','1');
      STOP;
   RUN;
   %IF NOT &l_filled %THEN %DO;
      %LET l_filled=%_delfile(&l_lstfile);
   %END;

   ODS _ALL_ CLOSE;

%MEND endTestcall;
/** \endcond */
