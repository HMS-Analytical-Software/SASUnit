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
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
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
   %LOCAL l_pgm l_auton l_object l_casid l_exaid l_num l_exafilename l_exapath l_exapgm;

   %LET l_object      = %lowcase (&i_object.);
   %LET l_auton       = %_getAutocallNumber(&l_object.);
   %IF (&l_auton. >= 2) %THEN %DO;
      %LET l_exafilename = &&g_sasautos.%eval(&l_auton.-2)/&l_object.;
   %END;
   %ELSE %IF (&l_auton. = 0) %THEN %DO;
      %LET l_exafilename = &g_sasunit./&l_object.;
   %END;
   %ELSE %IF (&l_auton. = 1) %THEN %DO;
      %LET l_exafilename = &g_sasunit_os./&l_object.;
   %END;
   %ELSE %DO;
      %LET l_exafilename = %_abspath(&g_root.,&l_object.);
   %END;
   %LET l_exafilename = %lowcase(&l_exafilename.);
   %LET l_exapath     = %_stdpath(&g_root.,&l_exafilename.);
   %LET l_num         = %sysfunc (find (&l_exafilename., /, -1200));
   %LET l_exapgm      = %substr  (&l_exafilename., %eval (&l_num+1));

   /* determine next test case id */
   %LET l_casid=0;
   %LET l_exaid=0;
   PROC SQL NOPRINT;
      SELECT max(cas_id) INTO :l_casid FROM target.cas
      WHERE cas_scnid = &g_scnid;
      SELECT exa_id INTO :l_exaid FROM target.exa
      WHERE lowcase (exa_pgm) = "&l_exapgm." and exa_auton=&l_auton.;
   %IF &l_casid=. %THEN %LET l_casid=1;
   %ELSE                %LET l_casid=%eval(&l_casid+1);
   /* save metadata for this test case  */
      %IF &l_exaid. = 0 %THEN %DO;
         SELECT sum (max (exa_id),0)+1 INTO :l_exaid FROM target.exa;
         INSERT INTO target.exa VALUES (
             &l_exaid.
            ,&l_auton.
            ,"&l_exapgm."
            ,%sysfunc(datetime())
            ,"&l_exafilename."
            ,"&l_exapath."
            ,.
         );
      %END;
      INSERT INTO target.cas VALUES (
          &g_scnid.
         ,&l_casid.
         ,&l_exaid.
         ,"&i_object."
         ,"&i_desc."
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
