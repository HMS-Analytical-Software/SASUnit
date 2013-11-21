/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Checks whether a foreign key relationship between the fields in two data sets exists.

               It is possible to check for a foreign key relationship for composite keys. Number of specified keys in parameters i_mstKey and i_lookupKey
               must be the same and keys have to in the same order.
               If more than one key is specified please provide parameter i_cmpKeyLen with number of keys
               Eventualy needed renaming of key variables takes place automatically               
                     
               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision: 191 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-06-05 15:23:22 +0200 (Mi, 05 Jun 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/assertForeignKey.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_mstrLib            Library of data set treated as master table
   \param   i_mstMem             Member name of data set treated as master table
   \param   i_mstKey             Key or keys of the master table. Multiple keys have to be separated by blank
   \param   i_unique             Optional parameter: by default set to true
   \param   i_lookupLib          Library of data set treated as lookup table
   \param   i_lookupMem          Member name of data set treated as lookup table
   \param   i_lookupKey          Key or keys of the master table. Multiple keys have to be separated by blank
   \param   i_cmpKeyLen          Number of keys specified in i_mstKey and i_lookupKey
   \param   o_maxObsRprtFail     Optional parameter: maximum number of records to be listed where lookup failed. By default set to MAX
   \param   o_listingVars        Additional variables from master dataset to be listed. Additional variables have to be separated by blanks
   \param   o_treatMissings      Optional parameter: Handling of missing values in the master data set: Possible parameters are IGNORE, DISALLOW, VALUE(default)
   \param   i_desc               A description of the test                  

*/ /** \cond */ 

%MACRO assertForeignKey (i_mstrLib           = 
                        ,i_mstMem            = 
                        ,i_mstKey            = 
                        ,i_unique            = TRUE
                        ,i_lookupLib         = 
                        ,i_lookupMem         = 
                        ,i_lookupKey         = 
                        ,i_cmpKeyLen         = 1
                        ,o_maxObsRprtFail    = MAX
                        ,o_listingVars       = 
                        ,o_treatMissings     = VALUE
                        ,i_desc              = Check for foreign key relation
                        );

   %GLOBAL g_inTestcase;
   %LOCAL l_dsMstrName l_dsLookupName l_MstrVars l_LookupVars l_renameLookup l_actual l_helper l_helper1 l_vartypMstr 
          l_vartypLookup l_rc l_result l_cnt1 l_cnt2 l_casid l_tstid l_path i l_listingVars num_missing l_treatMissings
          l_treatMissing l_unique l_errMsg;

   %LET l_actual           = -999;
   %LET l_dsMstrName       = &i_mstrLib..&i_mstMem.;
   %LET l_dsLookupName     = &i_lookupLib..&i_lookupMem.;
   %LET i_mstKey           = %SYSFUNC(compbl(&i_mstKey.));
   %LET i_lookupKey        = %SYSFUNC(compbl(&i_lookupKey.));
   %LET l_listingVars      = %SYSFUNC(COMPBL(&o_listingVars. %str( )));
   %LET l_treatMissings    = %SYSFUNC(upcase(&o_treatMissings.));
   %LET l_unique           = %SYSFUNC(upcase(&i_unique.));  
   %LET l_result           = 2;
   %LET l_errMsg           =;

   /*-- verify correct sequence of calls-----------------------------------------*/
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must be called after initTestcase;
      %RETURN;
   %END;
   
   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;
   
   %*** check for valid librefs und existence of data sets Master und Lookup***;
   %IF ((%SYSFUNC (libref (&i_mstrLib.)) NE 0) or (%SYSFUNC(exist(&l_dsMstrName)) EQ 0)) %THEN %DO;
      %LET l_actual =-1;
      %LET l_errMsg =Libref of master table not valid or data set does not exist;
      %GOTO Update;
   %END;
   %IF ((%SYSFUNC (libref (&i_lookupLib.)) NE 0) or (%SYSFUNC(exist(&l_dsLookupName)) EQ 0)) %THEN %DO;
      %LET l_actual =-2;
      %LET l_errMsg =Libref of lookup table not valid or data set does not exist;
      %GOTO Update;
   %END;

   %*** Is the number of keys specified in i_cmpKeyLen the same as actually specified in i_mstKey and i_lookupKey***;
   %LET l_helper = %eval(%SYSFUNC(count(&i_mstKey,%str( )))+1);
   %IF (&l_helper. NE &i_cmpKeyLen.) %THEN %DO;
      %LET l_actual =-3;
      %LET l_errMsg =Number of keys found in i_mstKey not compatible to specified number;
      %GOTO Update;
   %END;
   %LET l_helper = %eval(%SYSFUNC(count(&i_lookupKey,%str( )))+1);
   %IF (&l_helper. NE &i_cmpKeyLen.) %THEN %DO;
      %LET l_actual =-4;
      %LET l_errMsg =Number of found keys in i_lookupKey not compatible to specified number;
      %GOTO Update;
   %END;

   %*** Extract given keys to local variables***;  
   %DO i=1 %TO &i_cmpKeyLen.;
      %local l_mstKey&i l_lookupKey&i;
      %LET l_mstKey&i      = %SYSFUNC(scan(&i_mstKey, &i., " "));
      %LET l_lookupKey&i   = %SYSFUNC(scan(&i_lookupKey, &i., " "));
   %END;

   %*** Check if parameter o_maxObsRprtFail is valid ***;
   %IF NOT (%SYSFUNC(upcase(&o_maxObsRprtFail.)) = MAX) %THEN %DO;
      %IF (%datatyp(&o_maxObsRprtFail.) ~=NUMERIC) %THEN %DO;
         %LET l_actual =-19;
         %LET l_errMsg =%bquote(Parameter o_maxObsRprtFail (&o_maxObsRprtFail): MAX or numeric GE 0);
         %GOTO Update;
      %END;
      %ELSE %IF (&o_maxObsRprtFail. < 0) %THEN %DO;
         %LET l_actual =-20;
         %LET l_errMsg =%bquote(Parameter o_maxObsRprtFail(&o_maxObsRprtFail) < 0);
         %GOTO Update;
      %END;  
   %END;
      
   %*** Check existence of specified keys in their respective tables***;
   %*** open specified tables ***; 
   %LET l_dsMstid    = %SYSFUNC(open(&l_dsMstrName.));
   %LET l_dsLookupid = %SYSFUNC(open(&l_dsLookupName.));
   %*** opened correctly? ***; 
   %IF (&l_dsMstid. EQ 0 or &l_dsLookupid. EQ 0) %THEN %DO;
      %LET l_actual = -9;
      %LET l_errMsg =Open function failed;
      %GOTO Update;
   %END;

   %*** loop through all variables ***;
   %DO i=1 %TO &i_cmpKeyLen.;
      %LET l_helper   = %SYSFUNC(varnum(&l_dsMstid., &&l_mstKey&i.));
      %IF  &l_helper. = 0 %THEN %DO;
         %* specified variable not found;
         %LET l_actual = -5;
         %LET l_errMsg =Key in master table not found;
         %GOTO Update;           
      %END;
      %ELSE %DO;
         %* specified variable found: get variable type;
         %LET l_vartypMstr = %SYSFUNC(vartype(&l_dsMstid., &l_helper.));
         
         %*** Concatenate String for sql where condition: find missing values ***;
         %IF &l_vartypMstr. =N %THEN %DO;
            %LET l_helper1 = %str(.); 
         %END;
         %ELSE %DO;
            %LET l_helper1 = %str(""); 
         %END;
         %*** Insert or into sql where condition if loop runs more than once ***;
         %IF &i > 1 %THEN %DO;
            %LET l_treatMissing = &l_treatMissing. OR;
         %END;
         %LET l_treatMissing = &l_treatMissing.  &&l_mstKey&i. %str(=) &l_helper1;
      %END;

      %LET l_helper = %SYSFUNC(varnum(&l_dsLookupid.,&&l_lookupKey&i.));
      %IF (&l_helper. EQ 0) %THEN %DO;
         %* specified variable not found;
         %LET l_actual = -6;
         %LET l_errMsg = Key in lookup table not found;
         %GOTO Update;           
      %END;
      %ELSE %DO;
         %* specified variable found: get variable type;
         %LET l_vartypLookup = %SYSFUNC(vartype(&l_dsLookupid., &l_helper.));
      %END;

      %* Same Data Type?;
      %IF (&l_vartypMstr. NE  &l_vartypLookup.) %THEN %DO;
         %* specified variable not found;
         %LET l_actual = -7;
         %LET l_errMsg =Variable types of keys in master and lookup table do not match;
         %GOTO Update;           
      %END;
   %END;

   %*** loop through l_listingVars: Check if valid ***;
   %LET i = 1;
   %LET l_helper1 = %SYSFUNC(scan(&l_listingVars., &i., %str( )));
   
   %DO %UNTIL (&l_helper1=%str( ));
      %IF (&l_helper1. =) %THEN %DO;
         %GOTO Continue;
      %END;
      %LET l_helper   = %SYSFUNC(varnum(&l_dsMstid., &l_helper1.));
      %IF  &l_helper. = 0 %THEN %DO;
         %* specified variable not found;
         %LET l_actual = -21;
         %LET l_errMsg =%bquote(Parameter o_listingVars (&l_listingVars) not found in Master Table);
         %GOTO Update;           
      %END;  
      %LET i = %eval(&i+1);
      %LET l_helper1 = %SYSFUNC(scan(&l_listingVars., &i., %str( )));
   %END;
   %Continue:
   %LET l_listingVars= &i_mstKey. &l_listingVars.;
   %LET l_rc=%SYSFUNC(close(&l_dsMstid.));
   %LET l_rc=%SYSFUNC(close(&l_dsLookupid.));

   %*** parameter l_treatMissings: handle different cases ***;
   %*** make local copy of master table*;
   data mstrCopy;
      set &l_dsMstrName.;
   run; 

   %*** check for valid parameters*;
   %IF (&l_treatMissings. NE IGNORE AND &l_treatMissings. NE DISALLOW AND &l_treatMissings. NE VALUE) %THEN %DO;
      %LET l_actual = -22;
      %LET l_errMsg = %bquote(Invalid argument für parameter treatMissings (&l_treatMissings));
      %GOTO Update;
   %END;

   %*** get number of missing keys in master table*;
   PROC SQL;
      create table master_missing as
      select *
      from mstrCopy
      where &l_treatMissing.;
      ;
   QUIT; 
   
   %***get number of observations ***;
   %LET l_helper     =%SYSFUNC(open(master_missing));
   %LET num_missing  =%SYSFUNC(attrn(&l_helper,nlobs));
   %LET l_rc         =%SYSFUNC(close(&l_helper)); 
   
   %*** Exit if missings were found***;
   %IF ("&l_treatMissings." = "DISALLOW" AND &num_missing. GT 0) %THEN %DO;
      %LET l_actual = -23;
      %LET l_errMsg = %str(Parameter treatMissingsMst set to disallow, but missings found in master table);
      %GOTO Update;
   %END;
   %ELSE %IF ("&l_treatMissings." EQ "IGNORE") %THEN %DO;
      %*** delete missing values ***;
      PROC SQL;
         delete from mstrCopy
         where &l_treatMissing.;
         ;
      QUIT;
   %END;

   %*** check for valid parameter i_unique ***;
   %IF (&l_unique. NE TRUE AND &l_unique. NE FALSE) %THEN %DO;
      %LET l_actual = -24;
      %LET l_errMsg =Value for parameter i_unique not valid (&l_unique);
      %GOTO Update;
   %END;

   %*************************************************************;
   %*** start tests                                           ***;
   %*************************************************************;
   
   %*** Get distinct values from lookup table***;
   %DO i=1 %to &i_cmpKeyLen.;
      %IF (&i>1) %THEN %DO;
         %*** Insert comma into sql select clause ***;
         %LET l_LookupVars    = &l_LookupVars. ,;
      %END;
      %LET l_MstrVars      = &l_MstrVars. &&l_mstKey&i.;
      %LET l_LookupVars    = &l_LookupVars. &&l_lookupKey&i.;
      %LET l_renameLookup  = &l_renameLookup. &&l_lookupKey&i.=&&l_mstKey&i.;
   %END;

   %*** Check whether specified key is unique for lookup table ***;
   PROC SQL noprint;
      create table distKeysLookUp as
      SELECT distinct &l_LookupVars.
      FROM &l_dsLookupName.
      ;
   QUIT;

   %*** Count nobs from specified lookup table: May contain duplicate key values***;
   PROC SQL noprint;
      SELECT count(*) into :l_cnt1
      FROM &l_dsLookupName.
      ;
   QUIT;
   
   %*** Count nobs in distKeysLookUp: Contains only distinct keys***;
   PROC SQL noprint;
      SELECT count(*) into: l_cnt2
      FROM work.distKeysLookUp
      ;
   QUIT;

   %*** Is parameter l_unique set to true -> are duplicates allowed? ***;
   %IF (("&l_unique." EQ "TRUE") AND (&l_cnt1. NE &l_cnt2.)) %THEN %DO;
         %LET l_actual = -8;
         %LET l_errMsg =%str(Specified key of lookup table not unique, check parameter i_unique or lookup table);
      %GOTO Update;
   %END;
   %*** if parameter l_unique is set to false, put warning to log, but go on processing ***;
   %ELSE %IF (("&l_unique." EQ "FALSE") AND (&l_cnt1. NE &l_cnt2.))%THEN %DO;
      %PUT g_warning.(SASUNIT): Parameter i_unique set to false and lookup table not unique;
   %END;

   %*** Check whether all keys in the master table are available in the lookup table***;
   proc sort data = mstrCopy out = mstrSorted;
      by &l_MstrVars;
   run;     
   data keyNotFndMstr keyNotFndLookUp;
      merge mstrSorted(in=fndMstr) distKeysLookUp(in=fndLookUp rename=(&l_renameLookup.));
      by &l_MstrVars.;
      if     fndLookUp AND not   fndMstr then output keyNotFndMstr;
      If not fndLookUp AND       fndMstr then output keyNotFndLookUp;
   run;

   %*** Who many keys from the master table were not found in the lookup table ***;
   %LET l_helper  =%SYSFUNC(OPEN(work.keyNotFndLookUp,IN));
   %LET l_actual  =%SYSFUNC(ATTRN(&l_helper,NOBS));
   %LET l_rc      =%SYSFUNC(CLOSE(&l_helper));

   %*** Test successful? l_actual < 0 -> error_message, l_actual > 0 -> no foreign key relationship***;
   %IF (&l_actual. = 0) %THEN %DO;
      %LET l_result = 0;
   %END;
   
   %IF (&l_actual. > 0) %THEN %DO;
      %LET l_errMsg = &l_actual. key(s) not found in lookup table;
   %END;  

   /*-- get current ids for test case and test ---------------------------------*/
   %_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid);

   %*** create subfolder ***;
   %_createTestSubfolder (i_assertType  =assertForeignKey
                         ,i_scnid      =&g_scnid.
                         ,i_casid      =&l_casid.
                         ,i_tstid      =&l_tstid.
                         ,r_path       =l_path
                          );

   /* copy data sets if they exist  */
   %LET l_helper= %SYSFUNC(getoption(work));
   libname tar_afk "&l_path.";
   %IF %SYSFUNC(fileexist(&l_helper./keyNotFndLookUp.sas7bdat)) NE 0 %THEN %DO;
      /*Subset data set, keep only key variables + variables specified in l_listingVars*/
      data keyNotFndLookUp;
         set keyNotFndLookUp(OBS=&o_maxObsRprtFail.);
         keep &l_listingVars;
      run;   
   
      proc copy in = work out = tar_afk;
         select keyNotFndLookUp;
      run;
   %END;
   %IF %SYSFUNC(fileexist(&l_helper./keyNotFndMstr.sas7bdat)) NE 0 %THEN %DO;
      data keyNotFndMstr;
         set keyNotFndMstr(OBS=&o_maxObsRprtFail.);
         keep &l_listingVars;
      run; 
   
      proc copy in = work out = tar_afk;
        select keyNotFndMstr;
      run;
   %END;

   %Update:
   %_asserts(i_type      = assertForeignKey
            ,i_expected = %str(&l_unique.)
            ,i_actual   = %str(&l_actual)
            ,i_desc     = &i_desc.
            ,i_result   = &l_result.
            ,i_errMsg   = &l_errMsg.
            )

%MEND assertForeignKey;
/** \endcond */
