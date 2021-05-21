/**
   \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      runs a program in a spawned process

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

   \param   i_program           Command file to be executed in a separate instance
   \param   i_scnid             Scenario id used to construct lognames
   \param   i_generateMcoverage Specifies whether to use mcoverage or not
   \param   r_sysrc             Name of macro variable holding rc of spawning call

   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.
*/ 
/** \cond */ 

%macro _runProgramSpawned(i_program           =
                         ,i_scnid             = 
                         ,i_generateMcoverage = 0
                         ,r_sysrc             = 
                         ,i_pgmIsScenario     = 1
                         );

   %local l_cmdFile l_parms l_tcgFilePath l_tcgOptionsString l_rc l_macname l_program;
   %let l_macname=&sysmacroname.;
   
   /*-- prepare sasuser ---------------------------------------------------*/
   %let l_cmdFile=%sysfunc(pathname(work))/prep_sasuser.sh;
   DATA _null_;
      FILE "&l_cmdFile.";
      PUT "#!/bin/bash";
      PUT "&g_removedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      PUT "&g_makedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      %IF %length(&g_sasuser) %THEN %DO;
         PUT "&g_copydir ""&g_sasuser"" ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      %END;
   RUN;
   %_executeCMDFile(&l_cmdFile.);
   %LET l_rc=%_delfile(&l_cmdFile.);

   /*-- set config and autoexec -------------------------------------------*/
   %let l_cmdFile=%sysfunc(pathname(work))/_runprogramspawned.sh;
   %LET l_parms=;
   %IF "&g_autoexec." NE "" %THEN %DO;
      %LET l_parms=&l_parms -autoexec ""&g_autoexec"";
   %END;
   %IF "&g_sascfg." NE "" %THEN %DO;
     options SET=SASCFGPATH "&g_sascfg.";
   %END;
 
   %IF &i_generateMcoverage. EQ 1 %THEN %DO;
      /*-- generate a local macro variable containing the 
           path to the generated coverage file if necessary ---------------*/
      %LET   l_tcgFilePath      = &g_scnLogFolder./&i_scnid..tcg;
      %LET   l_tcgOptionsString = options mcoverage mcoverageloc='%sysfunc(tranwrd(&l_tcgFilePath.,%str( ), %str(\ )))';
   %END;

   %_createScnLogConfigXmlFile (i_projectBinFolder=&g_project_bin.
                               ,i_scnid           =&i_scnid.
                               ,i_sasunitLanguage =%lowcase(&g_language.)
                               ,o_scnLogConfigfile=%sysfunc(pathname(WORK))/sasunit.scnlogconfig.xml
                               );
                               
   %let l_program=%_abspath(&g_root., &i_program.);
   DATA _null_;
      ATTRIB
         _sCmdString LENGTH = $32000
      ;
      FILE 
         "&l_cmdFile."
         LRECL=32000
      ;
    _sCmdString = 
      "" !! &g_sasstart. 
      !! " " 
      !! "&l_parms. "
      !! "-sysin ""%_adaptSASunitPathToOS(&l_program.)"" "
      %if (&i_pgmIsScenario. = 1) %then %do;
         !! "-initstmt ""&l_tcgOptionsString.; %nrstr(%%_scenario%(io_target=)&g_target%nrstr(%))"" "
      %end;
      !! "-print ""%_adaptSASunitPathToOS(&g_testout.)/&i_scnid..lst"" "
      !! "-noovp "
      !! "-nosyntaxcheck "
      !! "-mautosource "
      !! "-mcompilenote all "
      !! "-sasautos SASAUTOS -append SASAUTOS ""&g_sasunit"" "
      !! "-sasuser ""%sysfunc(pathname(work))/sasuser"" "
      !! "-logconfigloc ""%sysfunc(pathname(WORK))/sasunit.scnlogconfig.xml"" "
      !! "-logapplname ""Scenario"" "
      %if (&i_pgmIsScenario. = 1) %then %do;
      !! "-termstmt ""%nrstr(%%_termScenario())"" "
      %end;
      !! "";
      PUT "#!/bin/bash";
      PUT _sCmdString;
      PUTLOG _sCmdString;
   RUN;

   %_executeCMDFile(&l_cmdFile.,LE,2);
   %LET &r_sysrc. = &sysrc.;
   %LET l_rc=%_delfile(&l_cmdFile.);

   /*-- delete sasuser ----------------------------------------------------*/
   %let l_cmdFile=%sysfunc(pathname(work))/del_sasuser.sh;
   DATA _null_;
      FILE "&l_cmdFile.";
      PUT "#!/bin/bash";
      PUT "&g_removedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
   RUN;
   %_executeCMDFile(&l_cmdFile.);
   %LET l_rc=%_delfile(&l_cmdFile.);

   %mend _runprogramspawned;   

/** \endcond */
