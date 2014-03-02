/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether there are differences between the values of 
               the columns of two sas data sets (PROC COMPARE).

               The values of the two data sets are considered to match each other 
               if all columns existing in data set i_expected are also existing in 
               data set i_actual. <br />
               Optionally one can define a deviation for numerical values so that 
               all corresponding values can be deviating from each other less than 
               a maximal deviation of i_fuzz (Caution: this corresponds to the 
               parameter 'criterion' of PROC COMPARE, the parameter 'fuzz' has 
               a different meaning in the context of PROC COMPARE)

   
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
	\sa			For further details refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>. 
					Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_expected     data set with expected values
   \param   i_actual       data set with actual values
   \param   i_desc         description of the assertion to be checked \n
                           default: "Compare datasets"
   \param   i_fuzz         optional: maximal deviation of expected and actual values, 
                           only for numerical values 
   \param   i_allow        optional: accepted differences between data sets, default setting is DSLABEL LABEL COMPVAR<br />
                           DSLABEL  Data set labels differ <br />
                           DSTYPE   Data set types differ <br />
                           INFORMAT Variable has different informat <br /> 
                           FORMAT   Variable has different format <br />
                           LENGTH   Variable has different length <br />
                           LABEL    Variable has different label <br />
                           BASEOBS  Base data set has observation not in comparison <br />
                           COMPOBS  Comparison data set has observation not in base <br />
                           BASEBY   Base data set has BY group not in comparison <br />
                           COMPBY   Comparison data set has BY group not in base <br />
                           BASEVAR  Base data set has variable not in comparison <br />
                           COMPVAR  Comparison data set has variable not in base <br />
                           VALUE    A value comparison was unequal <br />
                           TYPE     Conflicting variable types <br />
                           BYVAR    BY variables do not match <br />
                           ERROR    Fatal error: comparison not done <br />
   \param   i_id           optional: Id-column for matching of observations    
   \param   o_maxReportObs optional: number of observations that are copied from the expected and actual
                                     data set. default setting is MAX
   \param   i_include      optional: include list of variables to match
   \param   i_exclude      optional: exclude list of variables to match

   \return  ODS-document containing a comparison report; moreover, if o_maxReportObs ne 0, the expected and 
            the actual data set are written to _acLib
            
*/ /** \cond */ 

%MACRO assertColumns (i_expected     =      
                     ,i_actual       =      
                     ,i_desc         = Compare datasets
                     ,i_fuzz         =      
                     ,i_allow        = DSLABEL LABEL COMPVAR
                     ,i_id           =       
                     ,o_maxReportObs = max
                     ,i_maxReportObs =      /* obsolete */
                     ,i_include      =
                     ,i_exclude      =
                     );

   %LOCAL l_allowSymbols l_i l_j l_symboli l_symbolj l_potenz l_mask l_casid l_tstid l_path l_errMsg;
   %LET l_errMsg=;

   /*-- possible values for i_allow ---------------------------------------------*/
   %LET l_allowSymbols=
      DSLABEL 
      DSTYPE 
      INFORMAT 
      FORMAT 
      LENGTH 
      LABEL 
      BASEOBS 
      COMPOBS 
      BASEBY 
      COMPBY 
      BASEVAR 
      COMPVAR 
      VALUE 
      TYPE 
      BYVAR 
      ERROR
   ;

   /*-- check parameter i_allow  ------------------------------------------------*/
   %LET l_mask=0;
   %LET l_i=0; 
   %DO %WHILE(%length(%scan(&i_allow,%eval(&l_i+1),%str( ))));
      %LET l_i = %eval (&l_i + 1);
      %LET l_symboli = %upcase(%scan(&i_allow, &l_i, %str( )));
      %LET l_j=0;
      %LET l_potenz=1;
      %DO %WHILE(%length(%scan(&l_allowSymbols,%eval(&l_j+1),%str( ))));
         %LET l_j = %eval (&l_j+1);
         %LET l_symbolj = %scan(&l_allowSymbols, &l_j, %str( ));
         %IF &l_symboli = &l_symbolj %THEN %goto label1;
         %LET l_potenz = &l_potenz*2;
      %END;
      %PUT &g_error.(SASUNIT): assertColumns: invalid symbol &l_symboli in parameter i_allow;
      %RETURN;
   %label1:
      %LET l_mask = %sysfunc(bor(&l_mask, &l_potenz));
   %END;

   /*-- support obsolete parameter i_maxReportObs -------------------------------*/
   %IF %length(&i_maxReportObs) %then %LET o_maxReportObs = &i_maxReportObs;

   /*-- input from parameter i_include should override the input from i_exclude--*/
   %IF (%length(&i_include) > 0 AND %length(&i_exclude) > 0) %THEN %DO;
     %PUT &g_warning.(SASUNIT): Both parameters i_include and i_exclude have been set.;
     %PUT &g_warning.(SASUNIT): I_exclude parameter will be dropped;
     %LET i_exclude =;
   %END;

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must be called after initTestcase;
      %RETURN;
   %END;

   /*-- get current ids for test case and test --------- ------------------------*/
   %_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid);

   %*** create subfolder ***;
   %_createTestSubfolder (i_assertType   =assertcolumns
                         ,i_scnid        =&g_scnid.
                         ,i_casid        =&l_casid.
                         ,i_tstid        =&l_tstid.
                         ,r_path         =l_path
                         );

   libname _acLib "&l_path.";

   /*-- check if actual dataset exists ------------------------------------------*/
   %LOCAL l_rc l_actual; 
   %IF NOT %sysfunc(exist(&i_actual,DATA)) AND NOT %sysfunc(exist(&i_actual,VIEW)) %THEN %DO;
      %LET l_rc=2;
      %LET l_actual=ERROR: actual table not found.;
      %LET l_errMsg=Actual table (&i_actual.) could not be found!;
   %END;

   /*-- check if expected dataset exists ----------------------------------------*/
   %ELSE %IF NOT %sysfunc(exist(&i_expected,DATA)) AND NOT %sysfunc(exist(&i_expected,VIEW))%THEN %DO;
      %LET l_rc=2;
      %LET l_actual=&l_actual ERROR: expected table not found.;
      %LET l_errMsg=Expected table (&i_expected.) could not be found!;
   %END;

   /*-- compare tables ----------------------------------------------------------*/
   %ELSE %DO;

      %LOCAL l_formchar l_orientation l_compResult;
      %LET l_formchar=%sysfunc(getoption(formchar));
      %LET l_orientation=%sysfunc(getoption(orientation));

      OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";
      OPTIONS ORIENTATION=portrait;

      ODS DOCUMENT NAME=_acLib._columns_rep(WRITE);
      TITLE;
      FOOTNOTE;
      PROC COMPARE
         BASE=&i_expected %IF %quote(&i_exclude) NE %THEN %str(%(DROP= &i_exclude%));
         COMPARE=&i_actual %IF %quote(&i_exclude) NE %THEN %str(%(DROP= &i_exclude%));

         %IF %quote(&i_fuzz) NE %THEN CRITERION=&i_fuzz METHOD=ABSOLUTE;
         ;
         %IF %quote(&i_id) NE %THEN %str(ID &i_id;);
         %IF %quote(&i_include) NE %THEN %str(VAR &i_include;);
      RUN;
      %PUT &g_note.(SASUNIT): sysinfo = &sysinfo;
      %LET l_compResult = &sysinfo;

      ODS DOCUMENT CLOSE;
      OPTIONS FORMCHAR="&l_formchar.";
      OPTIONS ORIENTATION=&l_orientation.;

   /*-- check proc compare result -----------------------------------------------*/
      %LET l_rc=%eval((%sysfunc(bxor(%sysfunc(bor(&l_mask,&l_compResult)),&l_mask)) NE 0)*2);

   /*-- format compare result ---------------------------------------------------*/
      %LET l_j=0;
      %LET l_potenz=1;
      %DO %WHILE(%length(%scan(&l_allowSymbols,%eval(&l_j+1),%str( ))));
         %LET l_j = %eval (&l_j+1);
         %LET l_symbolj = %scan(&l_allowSymbols, &l_j, %str( ));
         %IF %sysfunc(band(&l_compResult, &l_potenz)) %THEN %DO;
            %LET l_actual = &l_actual &l_symbolj;
         %END;
         %LET l_potenz = &l_potenz*2;
      %END;

      %IF (&l_rc eq 2) %THEN %DO;
         %LET l_errMsg=%str(Allowed return codes are %upcase(&i_allow), comparing &i_expected. with &i_actual. resulted in these return codes &l_actual.);
      %END;
   %END; /* i_expected and i_actual exist */

   /*-- update comparison result in test database -------------------------------*/
   %_asserts(i_type     = assertColumns
            ,i_expected = %upcase(&i_allow)
            ,i_actual   = &l_actual.
            ,i_desc     = &i_desc.
            ,i_result   = &l_rc.
            ,i_errMsg   = &l_errMsg.
            );

   /*-- write dataset set the target area ---------------------------------------*/
   %IF &o_maxreportobs NE 0 %THEN %DO;
      %IF %sysfunc(exist(&i_expected,DATA)) OR %sysfunc(exist(&i_expected,VIEW)) %THEN %DO;
         DATA _acLib._columns_exp;
            SET &i_expected (obs=&o_maxReportObs.);
         RUN;
      %END;

      %IF %sysfunc(exist(&i_actual,DATA)) OR %sysfunc(exist(&i_actual,VIEW)) %THEN %DO;
         DATA _acLib._columns_act;
            SET &i_actual (obs=&o_maxReportObs.);
         RUN;
      %END;
   %END;

   libname _acLib;

%MEND assertColumns;
/** \endcond */
