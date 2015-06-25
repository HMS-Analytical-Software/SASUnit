/** 
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

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

%macro CrossReferenceTest1;

   %local l_obs l_title;
   
   %let l_obs = 4; /* n_obs set to 4 */
   %let l_title =A Test with SASHelp.Class;

   data test;
      set sashelp.class;
   run;
   
   /* Call macro %CrossReferenceTest2 */
   %CrossReferenceTest2(i_obs=&l_obs.
                       ,i_title =&l_title.
                       );
              
   /* Another comment over 
      several
      lines including the call %CrossReferenceTest3 */
   
   data _null_;
      calc = %CrossReferenceTest4(var1=3,var2=4);
   run;
      
%mend CrossReferenceTest1;
/** \endcond */
