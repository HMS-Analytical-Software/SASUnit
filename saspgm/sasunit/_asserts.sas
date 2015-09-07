/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Called by assert macros, fills table tst

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param  i_type           type of check, name of the calling assert macro
   \param  i_expected       expected value
   \param  i_actual         actual value
   \param  i_desc           description of the check
   \param  i_result         result 0 .. OK, 1 .. manual check, 2 .. not OK
   \param  i_errMsg         optional: custom error message describinng the reason of the failure. Used to show up in jenkins output.\n
                            Message will be prefixed by '<assertType> failed: '.
   \param  r_casid          optional: return number of current test case 
   \param  r_tstid          optional: return number of this check within test case
*/ /** \cond */  


%MACRO _asserts (i_type     =       
                ,i_expected =       
                ,i_actual   =       
                ,i_desc     =       
                ,i_result   =   
                ,i_errMsg   = _NONE_ 
                ,r_casid    = _NONE_ 
                ,r_tstid    = _NONE_       
                );

   %LOCAL l_errMsg;

   %IF (&r_casid=_NONE_) %THEN %DO;
      %LOCAL l_casid;
      %LET r_casid=l_casid;
   %END;
   %IF (&r_tstid=_NONE_) %THEN %DO;
      %LOCAL l_tstid;
      %LET r_tstid=l_tstid;
   %END;

   %IF (&i_result. eq 0) %THEN %DO;
      %LET l_errMsg =&i_type.: assert passed.;
   %END;
   %ELSE %IF (&i_result. eq 1) %THEN %DO;
      %LET l_errMsg =&i_type.: assert passed, but manual check necessary.;
   %END;
   %ELSE %DO;
      %IF (%nrbquote(&i_errMsg.) eq _NONE_) %THEN %DO;
         %LET l_errMsg =%bquote(&i_type. failed: expected value equals &i_expected., but actual value equals &i_actual.);
      %END;
      %ELSE %DO;
         %LET l_errMsg =%bquote(&i_type. failed: &i_errMsg.);
      %END;
   %END;

   %IF (&g_verbose.) %THEN %DO;
         %PUT --------------------------------------------------------------------------------;
      %IF (&i_result. NE 2) %THEN %DO;
         %PUT &G_NOTE.(SASUNIT): &l_errMsg.;
      %END;
      %ELSE %DO;
         %PUT &G_ERROR.(SASUNIT): &l_errMsg.;
      %END;
         %PUT --------------------------------------------------------------------------------;
   %END;

   PROC SQL NOPRINT;
      /* determine number of test case */
      SELECT max(cas_id) INTO :&r_casid FROM target.cas WHERE cas_scnid=&g_scnid;
      %IF &&&r_casid=. %THEN %DO;
         %PUT --------------------------------------------------------------------------------;
         %PUT &g_error.(SASUNIT): _asserts: Error retrieving testcase id;
         %PUT --------------------------------------------------------------------------------;
         %RETURN;
      %END;
      /* generate a new check number */
      SELECT max(tst_id) INTO :&r_tstid 
      FROM target.tst 
      WHERE 
         tst_scnid = &g_scnid AND
         tst_casid = &&&r_casid
      ;
      %IF &&&r_tstid=. %THEN %LET &r_tstid=1;
      %ELSE                  %LET &r_tstid=%eval(&&&r_tstid+1);
      INSERT INTO target.tst VALUES (
          &g_scnid
         ,&&&r_casid
         ,&&&r_tstid
         ,"&i_type"
         ,%sysfunc(quote(&i_desc%str( )))
         ,%sysfunc(quote(&i_expected%str( )))
         ,%sysfunc(quote(&i_actual%str( )))
         ,&i_result
         ,"&l_errMsg"
      );
   QUIT;

   %PUT ========================== Check &&&r_casid...&&&r_tstid (&i_type) =====================================;

   %LET &r_casid = %sysfunc(putn(&&&r_casid,z3.));
   %LET &r_tstid = %sysfunc(putn(&&&r_tstid,z3.));

%MEND _asserts;
/** \endcond */
