/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      check whether directory exists 

   \%existDir(directory)

   \param   i_dir     complete path to directory to be checked
   \return  1 .. directory exists, 0 .. directory does not exists

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%MACRO _existDir(i_dir);
%LOCAL rc did filrf;
%LET filrf=_tmpf;
%LET rc=%sysfunc(filename(filrf,&i_dir));
%LET did=%sysfunc(dopen(_tmpf));
%IF &did NE 0 %THEN %DO;
   1
   %LET rc=%sysfunc(dclose(&did));
%END;
%ELSE %DO;
   0
%END;
%LET rc=%sysfunc(filename(filrf));
%MEND _existDir;
/** \endcond */
