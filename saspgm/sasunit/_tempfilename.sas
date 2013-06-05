/** \file
   \ingroup    SASUNIT_UTIL

   \brief      creates a unique name for a temporary dataset in the form 
               WORK.DATAxxx, where xxx is a consecutive integer.

               The calling program will create a dataset with this name. 
               All of these temporary datasets can be deleted at the end of the calling macro 
               by a call like \%delTempFiles (see delTempFiles.sas). 

               Important: in order to delete only datasets created in the calling macro program, 
               define the macro symbol l_first_temp before the first call to \%tempFileName: 
               \%LOCAL l_first_temp;

   CAll: \%LOCAL macvar; \%tempFileName(&macvar);

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   r_tempFile     name of maro variable to contain the generated name 
*/ /** \cond */ 

%MACRO _tempFileName(r_TempFile);

/* create empty dataset */
DATA;STOP;RUN;

/* store to macro variable */
%LET &r_TempFile=&syslast;
%PUT Temporary dataset %nrstr(&)&r_tempFile is &&&r_tempFile;

/* delete again, need only name */
PROC SQL NOPRINT; 
   DROP TABLE &&&r_TempFile;
QUIT;

/* store number of first dataset to l_first_temp */
%IF %symexist (l_first_temp) %THEN %DO;
   %IF &l_first_temp = %THEN %LET l_first_temp = %substr(&syslast,10);
%END;

%MEND _tempFileName;
/** \endcond */
