/** 
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Testmacro for listcalling

               Please refer to <A href="https://github.com/HMS-Analytical-Software/SASUnit/wiki/User's%20Guide" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

   \retval    o_result       Return code of the assert 0: OK / 1: ERROR
*/ /** \cond */ 

%macro CrossReferenceTest2(i_obs=
                          ,i_title=
                          );

   %local l_calc;
   
   data test2;
      l_calc = %CrossReferenceTest4(var1=2,var2=7);
   run;
   
   /* test created in macro %CrossReferenceTest1 */
   proc print data=test2 (obs=&i_obs.);
      title &i_title;
   run;
   title;
  
   %put i_nobs=&i_obs;
   
   %CrossReferenceTest3(&i_obs.);
   
%mend CrossReferenceTest2;
/** \endcond */
