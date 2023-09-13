/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _writeParameterToTestDBtsu.sas

   \version    \$Revision: 700 $
   \author     \$Author: klandwich $
   \date       \$Date: 2020-01-04 11:48:39 +0100 (Sa, 04 Jan 2020) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_mkdir_test.sas $
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

   \test New test calls that catch all messages
*/ /** \cond */ 

%initScenario(i_desc=Test of _writeParameterToTestDBtsu.sas);

%macro testcase(i_object=_writeParameterToTestDBtsu.sas, i_desc=%str(Insert into empty TestDB));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */
   %local 
      l_value
   ;

   data work.tsu;
      length tsu_parameterName $40 tsu_parameterValue $1000 tsu_parameterScope $1;
      stop;
   run;

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %_writeParameterToTestDBtsu (i_parameterName  = Hugo
                               ,i_parameterValue = findet Fritz doof
                               ,i_libref         = work
                               );

   %endTestcall()

   /* assert */
   %assertRecordCount (i_libref         = work
                      ,i_memname        = tsu
                      ,i_operator       = EQ
                      ,i_recordsExp     = 1
                      ,i_where          = tsu_parameterName="HUGO"
                      ,i_desc           = Count records for Parameter Hugo
                      );

   %assertRecordCount (i_libref         = work
                      ,i_memname        = tsu
                      ,i_operator       = EQ
                      ,i_recordsExp     = 1
                      ,i_desc           = Count all records
                      );

   %let l_value = _NONE_;
   proc sql noprint;
      select tsu_parameterValue into :l_value from work.tsu where tsu_parameterName = "HUGO";
   quit; 

   %assertEquals (i_expected = findet Fritz doof
                 ,i_actual   = &l_value.
                 ,i_desc     = Hugo findet Fritz doof
                 );
    
  
   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_writeParameterToTestDBtsu.sas, i_desc=%str(Insert into non-empty TestDB));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */
   %local 
      l_value
   ;

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %_writeParameterToTestDBtsu (i_parameterName  = Peter
                               ,i_parameterValue = findet Lisbeth niedlich
                               ,i_libref         = work
                               );

   %endTestcall()

   /* assert */
   %assertRecordCount (i_libref         = work
                      ,i_memname        = tsu
                      ,i_operator       = EQ
                      ,i_recordsExp     = 1
                      ,i_where          = tsu_parameterName="PETER"
                      ,i_desc           = Count records for Parameter Peter
                      );

   %assertRecordCount (i_libref         = work
                      ,i_memname        = tsu
                      ,i_operator       = EQ
                      ,i_recordsExp     = 2
                      ,i_desc           = Count all records
                      );

   %let l_value = _NONE_;

   proc sql noprint;
      select tsu_parameterValue into :l_value from work.tsu where tsu_parameterName = "PETER";
   quit; 

   %assertEquals (i_expected = findet Lisbeth niedlich
                 ,i_actual   = &l_value.
                 ,i_desc     = Peter findet Lisbeth niedlich
                 );
    
  
   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_writeParameterToTestDBtsu.sas, i_desc=%str(Update existing parameter));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */
   %local 
      l_value
   ;

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %_writeParameterToTestDBtsu (i_parameterName  = Peter
                               ,i_parameterValue = findet Hugo doof
                               ,i_libref         = work
                               );

   %endTestcall()

   /* assert */
   %assertRecordCount (i_libref         = work
                      ,i_memname        = tsu
                      ,i_operator       = EQ
                      ,i_recordsExp     = 1
                      ,i_where          = tsu_parameterName="PETER"
                      ,i_desc           = Count records for Parameter Peter
                      );

   %assertRecordCount (i_libref         = work
                      ,i_memname        = tsu
                      ,i_operator       = EQ
                      ,i_recordsExp     = 2
                      ,i_desc           = Count all records
                      );

   %let l_value = _NONE_;

   proc sql noprint;
      select tsu_parameterValue into :l_value from work.tsu where tsu_parameterName = "PETER";
   quit; 

   %assertEquals (i_expected = findet Hugo doof
                 ,i_actual   = &l_value.
                 ,i_desc     = Peter findet Hugo doof
                 );
    
  
   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%endScenario();
/** \endcond */