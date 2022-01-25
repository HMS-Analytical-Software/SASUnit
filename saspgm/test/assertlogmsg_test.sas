/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertLogMsg.sas

   \version    \$Revision: 642 $
   \author     \$Author: klandwich $
   \date       \$Date: 2019-03-26 07:51:01 +0100 (Di, 26 Mrz 2019) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/assertcolumns_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario(i_desc =Test of assertLogMsg.sas);

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%let l_filename = %sysfunc(pathname(work))/file_with_messages.txt;
data _NULL_;
   file "&l_filename.";
   put "LINE1: Here is some unimportant text";
   put " LINE2: Here is some unimportant text";
   put"&G_NOTE.: This note is to show, that regex is working.";
   put"&G_NOTE.: This note is to show, that regEx is case InSeNsItIvE working.";
run;

%initTestcase(i_object=assertLogMsg.sas, i_desc=reading log file without errors)
%endTestcall()
%assertLogMsg(i_logMsg  =^LINE1:
             ,i_desc    =string at the beginning of the line
             ,i_logfile =&l_filename.
             )
   %markTest();
      %assertDBValue(tst,type,assertLogMsg)
      %assertDBValue(tst,exp,1^LINE1:)
      %assertDBValue(tst,act,1)
      %assertDBValue(tst,res,0)
%assertLogMsg(i_logMsg  =^LINE2:
             ,i_desc    =string at the beginning of the line
             ,i_logfile =&l_filename.
             ,i_not     =1
             )
   %markTest();
      %assertDBValue(tst,type,assertLogMsg)
      %assertDBValue(tst,exp,2^LINE2:)
      %assertDBValue(tst,act,2)
      %assertDBValue(tst,res,0)
%assertLogMsg(i_logMsg  =LINE2:
             ,i_desc    =string not at the beginning of the line
             ,i_logfile =&l_filename.
             )
   %markTest();
      %assertDBValue(tst,type,assertLogMsg)
      %assertDBValue(tst,exp,1LINE2:)
      %assertDBValue(tst,act,1)
      %assertDBValue(tst,res,0)
%assertLogMsg(i_logMsg  =that reg.* is
             ,i_desc    =string with regexp - found
             ,i_logfile =&l_filename.
             )
   %markTest();
      %assertDBValue(tst,type,assertLogMsg)
      %assertDBValue(tst,exp,1that reg.* is)
      %assertDBValue(tst,act,1)
      %assertDBValue(tst,res,0)
%assertLogMsg(i_logMsg  =that regex.* is
             ,i_desc    =string with regexp - found
             ,i_logfile =&l_filename.
             )
   %markTest();
      %assertDBValue(tst,type,assertLogMsg)
      %assertDBValue(tst,exp,1that regex.* is)
      %assertDBValue(tst,act,1)
      %assertDBValue(tst,res,0)
%assertLogMsg(i_logMsg  =that reg.+ is
             ,i_desc    =string with regexp - found
             ,i_logfile =&l_filename.
             )
   %markTest();
      %assertDBValue(tst,type,assertLogMsg)
      %assertDBValue(tst,exp,1that reg.+ is)
      %assertDBValue(tst,act,1)
      %assertDBValue(tst,res,0)
%assertLogMsg(i_logMsg  =that regex.+ is
             ,i_desc    =string with regexp - not found
             ,i_logfile =&l_filename.
             ,i_not     =1
             )
   %markTest();
      %assertDBValue(tst,type,assertLogMsg)
      %assertDBValue(tst,exp,2that regex.+ is)
      %assertDBValue(tst,act,2)
      %assertDBValue(tst,res,0)
%assertLogMsg(i_logMsg  =insensitive
             ,i_desc    =string with regexp case sensitiv
             ,i_logfile =&l_filename.
             ,i_not     =1
             )
   %markTest();
      %assertDBValue(tst,type,assertLogMsg)
      %assertDBValue(tst,exp,2insensitive)
      %assertDBValue(tst,act,2)
      %assertDBValue(tst,res,0)      
%assertLogMsg(i_logMsg           =insensitive
             ,i_desc             =string with regexp case insensitiv
             ,i_logfile          =&l_filename.
             ,i_case_sensitive   =0
             )
   %markTest();
      %assertDBValue(tst,type,assertLogMsg)
      %assertDBValue(tst,exp,1insensitive)
      %assertDBValue(tst,act,1)
      %assertDBValue(tst,res,0)
%endTestcase(i_assertLog=(&g_runmode.=SASUNIT_BATCH))

%endScenario()
/** \endcond */ 