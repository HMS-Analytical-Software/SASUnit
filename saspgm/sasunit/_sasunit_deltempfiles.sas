/** \file
   \ingroup    SASUNIT_UTIL

   \brief      delete all SAS datasets in the form WORK.DATAxxx, see tempFileName.sas

          define global symbol g_deltempfiles_debug if datasets should not be deleted

          if l_first_temp has been set to a number by the calling program, (see macro tempFileName) 
          only temporary datasets beginning with that number will be deleted. 

   \%delTempFiles;
   \sa    tempFileName.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ 
/** \cond */ 

%MACRO _sasunit_delTempFiles;

%IF NOT %symexist(g_deltempfiles_debug) %THEN %DO;

DATA _null_;
   SET sashelp.vtable END=eof;
   WHERE libname = 'WORK' AND memname LIKE 'DATA%';
   IF _n_=1 THEN 
      CALL EXECUTE ('PROC SQL NOPRINT;');
%IF %symexist(l_first_temp) %THEN %DO;
   %IF &l_first_temp NE %THEN %DO;
   IF input(substr(memname,5),8.) >= &l_first_temp;
   %END;
%END;
   CALL execute ('DROP TABLE ' !! memname !! ';');
   IF eof THEN 
      CALL execute ('QUIT;');
RUN;

%END;

%MEND _sasunit_delTempFiles;
/** \endcond */
