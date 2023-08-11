/** 
   \file
   \ingroup    SASUNIT_TEST

   \brief      Testmacro for listcalling

               Please refer to <A href="https://github.com/HMS-Analytical-Software/SASUnit/wiki/User's%20Guide" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

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
