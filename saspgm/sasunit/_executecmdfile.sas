/** \file
   \ingroup    SASUNIT_UTIL

   \brief      execute an command file by operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_cmdFile    Command file to be executed by the OS
   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.

*/ 
/** \cond */ 

%macro _executeCMDFile(i_cmdFile
                      );
					  
   %if &sysscp. = LINUX %then %do;
      %_xcmd(chmod u+x "&i_cmdFile.")
      %_xcmd(sed -i -e 's/\r//g' "%sysfunc(pathname(work))/xx.cmd");
   %end;
   %_xcmd("&i_cmdFile.")

%mend _executeCMDFile;   

/** \endcond */