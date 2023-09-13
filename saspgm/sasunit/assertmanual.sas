/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Servers as a placeholder for manual actions. Similar the assetReport but does not rely on output files

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
            
   \param   i_desc         description of the assertion to be checked \n
                           default: "Manual assert serves as placeholder"

*/ /** \cond */ 
%MACRO assertManual (i_desc =Manual assert - serves as placeholder);

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestCase;
   %endTestCall(i_messageStyle=NOTE);
   %IF %_checkCallingSequence(i_callerType=assert) NE 0 %THEN %DO;      
      %RETURN;
   %END;

   %_asserts(
       i_type     =assertManual
      ,i_expected =
      ,i_actual   =
      ,i_desc     =&i_desc.
      ,i_result   =1
   )
%MEND assertManual;
/** \endcond */