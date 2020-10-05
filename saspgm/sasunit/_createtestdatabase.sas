/** 
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Creates test data base.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   libref Library for the test database (optional: Default=target)

*//** \cond */
%macro _createTestDataBase (libref=target);
   %_createtestdatatsu (libref=&libref.);
   %_createtestdatascn (libref=&libref.);
   %_createtestdatacas (libref=&libref.);
   %_createtestdatatst (libref=&libref.);
   %_createtestdataexa (libref=&libref.);
%mend _createTestDataBase;
/** \endcond */