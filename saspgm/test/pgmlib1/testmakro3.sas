/** 
   \file
   \ingroup    SASUNIT_TEST

   \brief      Testmacro for listcalling

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%macro Testmakro3(i_nobs);

   %local l_var;

   proc freq data=test;
      table sex*age;
      title "A Standard Frequency Output";
   run;
   Title;
   
   data var;
      var = %Testmakro4(var1=5,var2=3);
   run;
   
%mend Testmakro3;
/** \endcond */
