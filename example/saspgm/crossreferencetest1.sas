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
