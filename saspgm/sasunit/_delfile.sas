/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      delete an external file if it exists

   \%delfile (file)

   \param   i_file   full path and name of external file

   \return           0 if OK, system code otherwise

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%MACRO _delFile(
   i_file   
);

%LOCAL rc filrf;
%LET filrf=_tmpf;
%LET rc=%sysfunc(filename(filrf,&i_file));
%LET rc=%sysfunc(fdelete(_tmpf));
&rc
%LET rc=%sysfunc(filename(filrf));
%MEND _delFile;
/** \endcond */
