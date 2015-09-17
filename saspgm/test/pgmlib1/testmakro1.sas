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

%macro Testmakro1;
   %Local l_obs l_title;
   
   %let l_obs = 4; /* n_obs set to 4 */
   %let l_title =A Test with SASHelp.Class;
   data test;
      set sashelp.class;
   run;
   
   /* Call macro %Testmakro2 */
   %Testmakro2(i_obs   =&l_obs
              ,i_title =&l_title
              );
              
   /* Another comment over 
      several
      lines including the call %Testmakro3 */
   
   data _null_;
      calc = %Testmakro4(var1=3,var2=4);
   run;
      
%mend Testmakro1;
/** \endcond */
