/** \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      runs a program in a spawned process

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

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
                         );

   %local 
      l_cmdFile 
      l_parms 
      l_parenthesis 
      l_tcgFilePath 
      l_tcgOptionsString 
      l_tcgOptionsStringLINUX 
      l_rc 
      l_macname
      l_program
      l_target
      l_log
      l_testout
      l_sasunit
   ;

   %let l_macname=&sysmacroname.;
   
   /*-- prepare sasuser ---------------------------------------------------*/
   %let l_cmdFile=%sysfunc(pathname(work))/prep_sasuser.cmd;
   DATA _null_;
      FILE "&l_cmdFile.";
      PUT "&g_removedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      PUT "&g_makedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      %IF %length(&g_sasuser) %THEN %DO;
         PUT "&g_copydir ""&g_sasuser"" ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      %END;
   RUN;
   %_executeCMDFile(&l_cmdFile.);
   %LET l_rc=%_delfile(&l_cmdFile.);

   /*-- set config and autoexec -------------------------------------------*/
   %let l_cmdFile=%sysfunc(pathname(work))/_runprogramspawned.cmd;
   %LET l_parms=;
   %LET l_parenthesis=(;
   %IF "&g_autoexec" NE "" %THEN %DO;
      %LET l_parms=&l_parms -autoexec ""&g_autoexec"";
   %END;
   %IF "&g_sascfg" NE "" %THEN %DO;
     options SET=SASCFGPATH "&g_sascfg.";
   %END;
 
   %*** Need to escape blanks in various paths ***;
   %LET l_program=%_escapeblanks(&i_program.);
   %LET l_target =%_escapeblanks(&g_target.);
   %LET l_log    =%_escapeblanks(&g_log.);
   %LET l_testout=%_escapeblanks(&g_testout.);
   %LET l_sasunit=%_escapeblanks(&g_sasunit.);

   %IF &i_generateMcoverage. EQ 1 %THEN %DO;
      /*-- generate a local macro variable containing the 
           path to the generated coverage file if necessary ---------------*/
      %LET   l_tcgFilePath      = &l_log./&i_scnid..tcg;
      %LET   l_tcgOptionsString = options mcoverage mcoverageloc='&l_tcgFilePath.';
   %END;

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
      !! "-sysin &l_program. "
      !! "-initstmt "" &l_tcgOptionsString.; %nrstr(%%_scenario%(io_target=)%nrstr(&l_target)%nrstr(%);%%let g_scnid=)&i_scnid.;"" "
      !! "-log   &l_log/&i_scnid..log "
      !! "-print &l_testout/&i_scnid..lst "
      !! "-noovp "
      !! "-nosyntaxcheck "
      !! "-mautosource "
      !! "-mcompilenote all "
      !! "-sasautos &l_sasunit "
      !! "-sasuser %sysfunc(pathname(work))/sasuser "
      !! "-termstmt ""%nrstr(%%_termScenario())"" "
      !! "";
      PUT _sCmdString;
   RUN;

   %_executeCMDFile(&l_cmdFile.);
   %LET &r_sysrc. = &sysrc.;
   %LET l_rc=%_delfile(&l_cmdFile.);

   /*-- delete sasuser ----------------------------------------------------*/
   %let l_cmdFile=%sysfunc(pathname(work))/del_sasuser.cmd;
   DATA _null_;
      FILE "&l_cmdFile.";
      PUT "&g_removedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
   RUN;
   %_executeCMDFile(&l_cmdFile.);
   %LET l_rc=%_delfile(&l_cmdFile.);

   %mend _runprogramspawned;   

/** \endcond */
