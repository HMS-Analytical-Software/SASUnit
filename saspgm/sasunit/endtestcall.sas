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
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
*/ /** \cond */ 

%MACRO endTestcall(i_messageStyle=ERROR);

   %GLOBAL g_inTestCall g_inTestCase;

   %IF (&g_inTestCall. NE 1) %THEN %DO;
      %IF (&i_messageStyle=ERROR) %THEN %DO;
         %PUT &g_error.: endTestcall must be called after initTestcase!;
      %END;
      %ELSE %DO;
         %PUT &g_note.(SASUNIT): endTestcall already run by user. This call was issued from endTestcase.;
      %END;
      %RETURN;
   %END;

   %LET g_inTestCall=0;

   %LOCAL l_casid l_filled l_lstfile; 

   %IF (&g_runmode. ne SASUNIT_INTERACTIVE) %THEN %DO;
      /* restore log and listing of test scenario */
      %LET g_logfile  =&g_log/%substr(00&g_scnid,%length(&g_scnid)).log;
      %LET g_printfile=&&g_testout/%substr(00&g_scnid,%length(&g_scnid)).lst;

      PROC PRINTTO 
         LOG=LOG
         PRINT=PRINT
      ;
      RUN;
   %END;

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

   %IF (&g_runmode. ne SASUNIT_INTERACTIVE) %THEN %DO;
      /* delete listing if empty */
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
   %END;

   %if (&g_runmode. ne SASUNIT_INTERACTIVE) %then %do;
      ODS _ALL_ CLOSE;
   %end;

%MEND endTestcall;
/** \endcond */
