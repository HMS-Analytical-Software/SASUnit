/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Called by assert macros, fills table tst

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param  i_type           type of check, name of the calling assert macro
   \param  i_expected       expected value
   \param  i_actual         actual value
   \param  i_desc           description of the check
   \param  i_result         result 0 .. OK, 1 .. not OK, 2 .. manual check
   \param  r_casid          optional: return number of current test case 
   \param  r_tstid          optional: return number of this check within test case
*/ /** \cond */ 

/* change history
   07.02.2008 AM  Quoting für Texte verbessert, die doppelte Hochkommata enthalten
*/ 


%MACRO _sasunit_asserts (
    i_type     =       
   ,i_expected =       
   ,i_actual   =       
   ,i_desc     =       
   ,i_result   =       
   ,r_casid    =       
   ,r_tstid    =       
);

%IF &r_casid= %THEN %DO;
   %LOCAL l_casid;
   %LET r_casid=l_casid;
%END;
%IF &r_tstid= %THEN %DO;
   %LOCAL l_tstid;
   %LET r_tstid=l_tstid;
%END;

PROC SQL NOPRINT;
   /* determine number of test case */
   SELECT max(cas_id) INTO :&r_casid FROM target.cas WHERE cas_scnid=&g_scnid;
   %IF &&&r_casid=. %THEN %DO;
      %PUT &g_error: _sasunit_asserts: Fehler beim Ermitteln der Testfall-Id;
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
   );
QUIT;

%PUT ========================== Check &&&r_casid...&&&r_tstid (&i_type) =====================================;

%LET &r_casid = %sysfunc(putn(&&&r_casid,z3.));
%LET &r_tstid = %sysfunc(putn(&&&r_tstid,z3.));

%MEND _sasunit_asserts;
/** \endcond */
