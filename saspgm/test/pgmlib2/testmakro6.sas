/** 
   \file
   \ingroup    SASUNIT_TEST

   \brief      Testmacro for listcalling

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision: 456 $
   \author     \$Author: klandwich $
   \date       \$Date: 2015-09-17 14:15:34 +0200 (Do, 17 Sep 2015) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/pgmlib1/testmakro2.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%macro Testmakro6(i_obs=
                 ,i_title=
                 );

   %local l_calc;
   

   
   data test2;
      l_calc = %Testmakro4(var1=2,var2=7);
   run;
   
   /* test created in macro %Testmakro1 */
   proc print data=test2 (obs=&i_obs.);
      title &i_title;
   run;
   title;
  
   %put i_nobs=&i_obs;
   
   %Testmakro3;
   
%mend Testmakro6;
/** \endcond */
