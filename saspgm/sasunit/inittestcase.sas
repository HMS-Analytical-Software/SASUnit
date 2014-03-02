/**
   \file
   \ingroup    SASUNIT_SCN 

   \brief      Start of a new test case that comprises an invocation of
               a program under test and one or more assertions.

               internally: 
               - Insertion of relevant data into the test repository
               - Redirection of SAS log
               - Setting of flag g_inTestcase

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
					Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_object          source code file of program under test, is searched in 
                              the AUTOCALL path in case only the name of the source code 
                              file is given, without path information
   \param   i_desc            description of the test case
   \param   i_specdoc         optional: path of specification document
   \return  Information on current testcase in macro variables
   
	
*/ /** \cond */ 

%MACRO initTestcase(i_object   =  
                   ,i_desc     =  
                   ,i_specdoc  =  
                   );

   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
      %endTestcase;
   %END;
   %IF &g_inTestcase EQ 2 %THEN %DO;
      %endTestcase;
   %END;
   %LET g_inTestcase=1;

   /* handle absolute and relative paths for programs */
   %LOCAL l_pgm l_auton l_object l_casid;
   %LET l_object = %lowcase (&i_object.);
   %IF %index(%sysfunc(translate(&l_object,/,\)),/) %THEN %DO;
      %LET l_pgm = %_stdPath(&g_root,&i_object);
      %LET l_auton=.;
   %END;
   %ELSE %DO;
      %LET l_pgm = &i_object;
      %LET l_auton = %_getAutocallNumber(&l_object);
   %END;

   /* determine next test case id */
   %LET l_casid=0;
   PROC SQL NOPRINT;
      SELECT max(cas_id) INTO :l_casid FROM target.cas
      WHERE cas_scnid = &g_scnid;
   %IF &l_casid=. %THEN %LET l_casid=1;
   %ELSE                %LET l_casid=%eval(&l_casid+1);
   /* save metadata for this test case  */
      INSERT INTO target.cas VALUES (
          &g_scnid
         ,&l_casid
         ,&l_auton
         ,"&l_pgm"
         ,"&i_desc"
         ,"%_abspath(&g_doc,&i_specdoc)"
         ,%sysfunc(datetime())
         ,.
         ,.
      );
   QUIT;

   %PUT ========================== test case &l_casid ======================================================;

   /* reroute SASLOG and SASLIST */
   %LET g_logfile  =&g_log/%sysfunc(putn(&g_scnid,z3.))_%sysfunc(putn(&l_casid,z3.)).log;
   %LET g_printfile=&g_testout/%sysfunc(putn(&g_scnid,z3.))_%sysfunc(putn(&l_casid,z3.)).lst;
   PROC PRINTTO 
      NEW 
      LOG="&g_logfile."
      PRINT="&g_printfile."
   ;
   RUN;

%MEND initTestcase;
/** \endcond */
