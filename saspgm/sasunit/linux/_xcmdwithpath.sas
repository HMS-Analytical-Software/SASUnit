/**
   \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      run an operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

   \param   i_cmd_path     OS command parameters containing paths. Slashes will be transformed to Backslashes
   \param   i_cmd          OS command parameters that contain text
   \return  r_rc           Return Code of %sysexec 
   
 */ /** \cond */ 

%MACRO _xcmdWithPath(i_cmd_path =
                    ,i_cmd      =
                    ,r_rc       =l_rc
                    );
                    
   %LOCAL logfile l_cmd rc filrf;

   %LET logfile=%sysfunc(pathname(work))/___log.txt;
   %LET rc = %_delfile(&logfile);
   
   %LET l_cmd = %sysfunc(translate(&i_cmd_path.,/ ,\));
   %LET l_cmd = &l_cmd. &i_cmd.;
   
   %SYSEXEC &l_cmd > "&logfile";
   %LET &r_rc = &sysrc.;
   
   %IF &g_verbose. %THEN %DO;
      %PUT ======== OS Command Start ========;
       /* Evaluate sysexec´s return code*/
      %IF &l_rc. = 0 %THEN %PUT &g_note.(SASUNIT): Sysrc : 0 -> SYSEXEC SUCCESSFUL;
      %ELSE %PUT &g_error.(SASUNIT): Sysrc : &sysrc -> An Error occured;

      /* put sysexec command to log*/
      %PUT &g_note.(SASUNIT): SYSEXEC COMMAND IS: &l_cmd > "&logfile";
      
      /* write &logfile to the log */
      /* for the following commands "cd", "pwd", "setenv" or "umask" SAS executes
         SAS equivalent of these commands -> no files are generated that could be read */
      %LET filrf=_tmpf;
      %LET rc=%sysfunc(filename(filrf,&logfile));
      %LET rc = %sysfunc(fexist(&filrf));

      %IF (&rc) %THEN %DO;
         DATA _NULL_;
            infile "&logfile" truncover;
            input;
            putlog _infile_;
         RUN;
      %END;
      %ELSE %PUT No File Redirection for Commands cd, pwd, setenv and umask;
      %LET rc=%sysfunc(filename(filrf));
      
      %PUT ======== OS Command End ========;
   %END;
%MEND _xcmdWithPath; 

/** \endcond */

