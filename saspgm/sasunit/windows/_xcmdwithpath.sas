/** \file
   \ingroup    SASUNIT_UTIL_OS_WIN

   \brief      run an operation system command

   \version    \$Revision: 346 $
   \author     \$Author: klandwich $
   \date       \$Date: 2014-11-16 06:51:26 +0100 (So, 16 Nov 2014) $
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/windows/_xcmd.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_cmd_path     OS command parameters containing paths. Slashes will be transformed to Backslashes
   \param   i_cmd          OS command parameters that contain text
   \return  r_rc           Return Code of %sysexec 


 */ /** \cond */ 

%MACRO _xcmdWithPath(i_cmd_path =
                    ,i_cmd      =
                    ,r_rc       =l_rc
                    );

   %LOCAL xwait xsync xmin logfile l_cmd;
   
   %LET xwait=%sysfunc(getoption(xwait));
   %LET xsync=%sysfunc(getoption(xsync));
   %LET xmin =%sysfunc(getoption(xmin));
   
   %LET l_cmd = %sysfunc(translate(&i_cmd_path.,\ ,/));
   %LET l_cmd = &l_cmd. &i_cmd.;

   OPTIONS noxwait xsync xmin;
   
   %LET logfile=%sysfunc(pathname(work))\___log.txt;

   %SYSEXEC &l_cmd > "&logfile";
   %LET &r_rc = &sysrc.;

   %IF &g_verbose. %THEN %DO;
      %PUT ======== OS Command Start ========;
       /* Evaluate sysexec´s return code*/
      %IF &l_rc. = 0 %THEN %PUT &g_note.(SASUNIT): Sysrc : 0 -> SYSEXEC SUCCESSFUL;
      %ELSE %PUT &g_error.(SASUNIT): Sysrc : &sysrc -> An Error occured;

      /* put sysexec command to log*/
      %PUT &g_note.(SASUNIT): SYSEXEC COMMAND IS: &l_cmd > "&logfile";
      
      /* write &logfile to the log*/
      DATA _NULL_;
         infile "&logfile" truncover;
         input;
         putlog _infile_;
      RUN;
      
      %PUT ======== OS Command End ========;
   %END;

   OPTIONS &xwait &xsync &xmin;

%MEND _xcmdWithPath; 

/** \endcond */

