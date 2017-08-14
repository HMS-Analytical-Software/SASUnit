/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _readEnvMetadata.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

/*
%symdel envvar;
%symdel starttype;
/**/

/**/
options mprint mlogic symbolgen;
/**/
/* === Test case 1 ================================================ */
%initTestcase (i_object = _readEnvMetadata.sas
              ,i_desc   = successful call
              );

%_readEnvMetadata;

%let g_RPM =%sysfunc(translate (&g_runningProgram., /, \));
%let g_RPM =%scan (&g_RPM., -1, /);

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
%endTestcase();

/* === Test case 2 ================================================ */
%initTestcase (i_object = _readEnvMetadata.sas
              ,i_desc   = pretending to run in Enterprise Guide
              );

%let _CLIENTAPPABREV=EG;
%let _SASPROGRAMFILE=_readenvmetadata_test.sas;

%_readEnvMetadata;

%let g_RPM =%sysfunc(translate (&g_runningProgram., /, \));
%let g_RPM =%scan (&g_RPM., -1, /);

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

%*endScenario();
/** \endcond */
