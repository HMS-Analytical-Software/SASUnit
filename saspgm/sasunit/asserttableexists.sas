/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether a certain data set, view or catalogue exists. 
   
               Setting the optional parameter i_not to 1 allows to test whether a certain data set, view or catalogue does not exist. \n
               Step 1: Check whether library has been assigned successfully. \n
               Step 2: Check for existence with exist function
                     
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_libref       library in which the test candidate can be found
   \param   i_memname      name of data set, view or catalogue to be tested
   \param   i_target       optional: Explicit test for existence of a dataset,view or catalogue (Possible arguments: data, view, catalog). 
                              If i_target is not given data will be used as default.
   \param   i_desc         description of the assertion to be checked \n
                           default: "Check for existence of a specific dataset"
   \param   i_not          optional: negates the assertion, if set to 1. Set to 0 no negation takes place. 
                           If the library hasn't been assigned successfully parameter i_not has no effect.
                           
*/ /** \cond */

%MACRO assertTableExists (i_libref  =
                         ,i_memname =
                         ,i_target  = DATA
                         ,i_desc    = Check for existence of a specific dataset
                         ,i_not     = 0
                         );

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestCase g_inTestCall;
   %IF &g_inTestCall EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %IF &g_inTestCase NE 1 %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL l_dsname l_libref_ok l_table_exist l_result l_date l_suffix l_errMsg;
   %LET l_dsname     =%sysfunc(catx(., &i_libref, &i_memname));
   %LET l_table_exist=-1;
   %LET l_result     =2;
   %LET l_date       =;

   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;
   
   %*** check for valid libref ***;
   %LET l_libref_ok=%sysfunc (libref (&i_libref.));
   %IF &l_libref_ok. NE 0 %THEN %DO;
      %LET l_errMsg=Libref &i_libref. is invalid!;
      %goto Update;
   %END;
    
   %*** check if i_target is valid ***;
   %LET i_target=%sysfunc(upcase(&i_target));
   %IF not(&i_target=DATA or &i_target=VIEW or &i_target=CATALOG) %THEN %DO;
      %LET l_table_exist = -2;
      %LET l_errMsg=%bquote(Invalid value for parameter i_target (&i_target.)!);
      %goto Update;
   %END;

   %*************************************************************;
   %*** start tests                                           ***;
   %*************************************************************;
   
   %IF %sysfunc(exist(&l_dsname., &i_target.)) %THEN %DO;
      %LET l_table_exist=1;
      %PUT &g_note.(SASUNIT): &i_target. &l_dsname. exists.;
      %LET l_errMsg=&i_target &l_dsname exists;

      %*** get creation und modification date of tested member ***;
      data _null_ ;
         length _crdate _modate $20;
         dsid=open("&l_dsname") ;
         _crdate = attrn(dsid,'CRDTE');
         _modate = attrn(dsid,'MODTE');
         dsid=close(dsid) ;
         call symput('l_date',catt("#",_crdate,"#",_modate));
      run ;
   %END;
   %ELSE %DO;
      %PUT &g_note.(SASUNIT): &i_target. &l_dsname. does not exist.;
      %LET l_errMsg=&i_target &l_dsname does not exist;
      %LET l_table_exist=0;
   %END;

   %LET l_result = %eval(1 - &l_table_exist.);
   %LET l_suffix=%str(, but it should exist!);
   %IF (&i_not) %THEN %DO;
      %LET l_result = %eval(1 - &l_result.);
      %LET l_suffix=%str(, but it should not exist!);
   %END;
   %LET l_errMsg =&l_errMsg.&l_suffix.;
   %LET l_result = %eval(&l_result.*2);

   %Update:;
   %_asserts(i_type     = assertTableExists
            ,i_expected = %str(&i_target.:&l_dsname.:&i_not.)
            ,i_actual   = %str(&l_table_exist.&l_date.)
            ,i_desc     = &i_desc.
            ,i_result   = &l_result.
            ,i_errMsg   = &l_errMsg.
            )

%MEND assertTableExists;
/** \endcond */
