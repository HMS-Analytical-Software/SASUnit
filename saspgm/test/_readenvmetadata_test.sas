/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _readEnvMetadata.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \test Add test cases pretending to run in Jupyter Notebook and interactively
         Two other conditions to recognize SEG
*/ /** \cond */ 

%initScenario(i_desc=Test of _readEnvMetadata.sas);

/* === Test case 1 ================================================ */
%initTestcase (i_object = _readEnvMetadata.sas
              ,i_desc   = successful call
              );

%_readEnvMetadata;

%let g_RPMFN=&g_runningProgramFullName.;
%let g_RPM  =%scan (&g_RPMFN., -1, /);

%endTestCall;

%assertEquals (i_expected=SASUNIT_DMS
              ,i_actual  =&g_runEnvironment.
              ,i_desc    =Runtime environment is Display Manager
              );
%assertEquals (i_expected=SASUNIT_BATCH
              ,i_actual  =&g_runMode.
              ,i_desc    =Running mode ist Batch
              );
%assertEquals (i_expected=_readenvmetadata_test.sas
              ,i_actual  =&g_RPM.
              ,i_desc    =Running Program is this scenario
              );
%assertEquals (i_expected=XCMD
              ,i_actual  =&g_xcmd.
              ,i_desc    =Setting of XCMD system option
              );
%assertEquals (i_expected=_dir
              ,i_actual  =&g_dirMacro.
              ,i_desc    =Name of corresponding dir macro
              );
%endTestcase();

/* === Test case 2 ================================================ */
%initTestcase (i_object = _readEnvMetadata.sas
              ,i_desc   = pretending to run in Enterprise Guide
              );

%let _CLIENTAPPABREV=EG;
%let _SASPROGRAMFILE=\saspgm\test\_readenvmetadata_test.sas;

%_readEnvMetadata;

%let g_RPMFN=&g_runningProgramFullName.;
%let g_RPM  =%scan (&g_RPMFN., -1, /);

%endTestCall
%assertEquals (i_expected=SASUNIT_SEG
              ,i_actual  =&g_runEnvironment.
              ,i_desc    =Runtime environment is Display Manager
              );
%assertEquals (i_expected=SASUNIT_BATCH
              ,i_actual  =&g_runMode.
              ,i_desc    =Running mode ist Batch
              );
%assertEquals (i_expected=_readenvmetadata_test.sas
              ,i_actual  =&g_RPM.
              ,i_desc    =Running Program is this scenario
              );
%endTestcase();

/* === Test case 3 ================================================ */
%initTestcase (i_object = _readEnvMetadata.sas
              ,i_desc   = pretending to run in SAS Studio
              );

%let _EXECENV=SASStudio;
%let _SASPROGRAMFILE=\saspgm\test\_readenvmetadata_test.sas;

%_readEnvMetadata;

%let g_RPMFN=&g_runningProgramFullName.;
%let g_RPM  =%scan (&g_RPMFN., -1, /);

%endTestCall
%assertEquals (i_expected=SASUNIT_SASSTUDIO
              ,i_actual  =&g_runEnvironment.
              ,i_desc    =Runtime environment is Display Manager
              );
%assertEquals (i_expected=SASUNIT_BATCH
              ,i_actual  =&g_runMode.
              ,i_desc    =Running mode ist Batch
              );
%assertEquals (i_expected=_readenvmetadata_test.sas
              ,i_actual  =&g_RPM.
              ,i_desc    =Running Program is this scenario
              );
%endTestcase();

%symdel _EXECENV;
%symdel _SASPROGRAMFILE;
%symdel _CLIENTAPPABREV;

%endScenario();
/** \endcond */