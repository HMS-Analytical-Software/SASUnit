/** 
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Testmacro for listcalling

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

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
