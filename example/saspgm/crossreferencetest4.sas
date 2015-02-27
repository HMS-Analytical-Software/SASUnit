/** 
   \file
   \ingroup    none

   \brief      Testmacro for listcalling

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision: 205 $
   \author     \$Author: klandwich $
   \date       \$Date: 2013-07-05 10:38:34 +0200 (Fr, 05 Jul 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_assertlibrary.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.


   \retval    o_result       Return code of the assert 0: OK / 1: ERROR
*/ /** \cond */ 

%macro CrossReferenceTest4 (var1 =
                           ,var2 =
                           );
                   
   %local result;

   %let result = %eval(&var1. + &var2.);

   &result;

%mend CrossReferenceTest4;
/** \endcond */
