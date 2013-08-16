/** \file
   \ingroup    SASUNIT_UTIL

   \brief      runs a program in a spawned process

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_program           Command file to be executed in a separate instance
   \param   i_scnid             Scenario id used to construct lognames
   \param   i_generateMcoverage Specifies whether to use mcoverage or not
   \param   i_sysrc             Name of macro variable holding rc of spawning call

   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.
*/ 
/** \cond */ 

%macro _runProgramSpawned(i_program           =
                         ,i_scnid             = 
                         ,i_generateMcoverage = 0
                         ,i_sysrc             = 
                         );

   %local l_cdmFile l_parms l_parenthesis l_tcgFilePath l_tcgOptionsString l_tcgOptionsStringLINUX l_rc;
   %let l_cmdFile=%sysfunc(pathname(work))/_runprogramspawned.cmd;
   
   /*-- prepare sasuser ---------------------------------------------------*/
   DATA _null_;
      FILE "%sysfunc(pathname(work))/x.cmd";
      PUT "&g_removedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      PUT "&g_makedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      %IF %length(&g_sasuser) %THEN %DO;
         PUT "&g_copydir ""&g_sasuser"" ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      %END;
   RUN;
   %_executeCMDFile(%sysfunc(pathname(work))/x.cmd);
   %LET l_rc=_delfile(%sysfunc(pathname(work))/x.cmd);

   /*-- set config and autoexec -------------------------------------------*/
   %LET l_parms=;
   %LET l_parenthesis=(;
   %IF "&g_autoexec" NE "" %THEN %DO;
      %LET l_parms=&l_parms -autoexec ""&g_autoexec"";
   %END;
   %IF &sysscp. = LINUX %THEN %DO;
       %IF "&g_sascfg" NE "" %THEN %DO;
          options SET=SASCFGPATH "&g_sascfg.";
       %END;
   %END;
   %ELSE %DO;
       %IF "&g_sascfg" NE "" %THEN %DO;
           %LET l_parms=&l_parms -config ""&g_sascfg"";
       %END;
       %ELSE %IF %length(%sysfunc(getoption(config))) NE 0 AND %index(%quote(%sysfunc(getoption(config))),%bquote(&l_parenthesis)) NE 1 %THEN %DO; 
          %LET l_parms=&l_parms -config ""%sysfunc(getoption(config))"";
       %END; 
   %END;
 
   %IF &i_generateMcoverage. EQ 1 %THEN %DO;
      /*-- generate a local macro variable containing the 
           path to the generated coverage file if necessary ---------------*/
      %LET   l_tcgFilePath           = &g_log./&i_scnid..tcg;
      %LET   l_tcgOptionsString      = -mcoverage -mcoverageloc = %str(%")%str(%")&l_tcgFilePath.%str(%")%str(%");
      %LET   l_tcgOptionsStringLINUX = options mcoverage mcoverageloc='%sysfunc(tranwrd(&l_tcgFilePath.,%str( ), %str(\ )))';
   %END;

   DATA _null_;
      ATTRIB
         _sCmdString LENGTH = $32000
      ;
      FILE 
         "&l_cmdFile."
         LRECL=32000
      ;
      %IF &sysscp. = LINUX %THEN %DO;
         _sCmdString = 
            "" !! &g_sasstart. 
            !! " " 
            !! "&l_parms. "
            !! "-sysin %sysfunc(tranwrd(&i_program., %str( ), %str(\ ))) "
            !! "-initstmt "" &l_tcgOptionsStringLINUX.; %nrstr(%%_scenario%(io_target=)&g_target%nrstr(%);%%let g_scnid=)&i_scnid.;"" "
            !! "-log   %sysfunc(tranwrd(&g_log/&i_scnid..log, %str( ), %str(\ ))) "
            !! "-print %sysfunc(tranwrd(&g_testout/&i_scnid..lst, %str( ), %str(\ ))) "
            !! "-noovp "
            !! "-nosyntaxcheck "
            !! "-noterminal "
            !! "-mautosource "
            !! "-mcompilenote all "
            !! "-sasautos %sysfunc(tranwrd(&g_sasunit, %str( ), %str(\ ))) "
            !! "-sasuser %sysfunc(pathname(work))/sasuser "
            !! "-termstmt ""%nrstr(%%_termScenario())"" "
            !! "";
      %END;
      %ELSE %DO;
         _sCmdString = 
            """" !! &g_sasstart !! """"
            !! " " 
            !! "&l_parms. "
            !! "-sysin ""&i_program."" "
            !! "-initstmt ""%nrstr(%%%_scenario%(io_target=)&g_target%nrstr(%);%%%let g_scnid=)&i_scnid.;"" "
            !! "-log   ""&g_log/&i_scnid..log"" "
            !! "-print ""&g_testout/&i_scnid..lst"" "
            !! "&g_splash "
            !! "-noovp "
            !! "-nosyntaxcheck "
            !! "-mautosource "
            !! "-mcompilenote all "
            !! "-sasautos ""&g_sasunit"" "
            !! "-sasuser ""%sysfunc(pathname(work))/sasuser"" "
            !! "-termstmt ""%nrstr(%%%_termScenario())"" "
            !! "&l_tcgOptionsString. "
            !! "";
      %END;
      PUT _sCmdString;
   RUN;

   %_executeCMDFile(&l_cmdFile.);
   %LET &i_sysrc. = &sysrc.;
   %LET l_rc=_delfile(&l_cmdFile.);

   /*-- delete sasuser ----------------------------------------------------*/
   DATA _null_;
      FILE "%sysfunc(pathname(work))/x.cmd";
      PUT "&g_removedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
   RUN;
   %_executeCMDFile(%sysfunc(pathname(work))/x.cmd);
   %LET l_rc=_delfile(%sysfunc(pathname(work))/x.cmd);
%mend _runprogramspawned;   

/** \endcond */
