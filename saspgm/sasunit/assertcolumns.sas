/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether there are differences between the values of 
               the columns of two sas data sets (PROC COMPARE).

               Please refer to the description of the test tools in _sasunit_doc.sas

               The values of the two data sets are considered to match each other
               if all columns existing in data set i_expected are also existing in 
               data set i_actual and if all coresponding values are deviating from
               each other less than a maximal deviation of i_fuzz (Caution: this
               corresponds to the parameter 'criterion' of PROC COMPARE, the 
               parameter 'fuzz' has a different meaning in the context of PROC COMPARE)

   
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_expected     data set with expected values
   \param   i_actual       data set with actual values
   \param   i_desc         description of the assertion to be checked
   \param   i_fuzz         optional: maximal deviation of expected and actual values, 
                           only for numerical values 
   \param   i_allow        optional: accepted differences between data sets, default setting is DSLABEL LABEL COMPVAR
                           DSLABEL  Data set labels differ 
                           DSTYPE   Data set types differ 
                           INFORMAT Variable has different informat 
                           FORMAT   Variable has different format 
                           LENGTH   Variable has different length 
                           LABEL    Variable has different label 
                           BASEOBS  Base data set has observation not in comparison 
                           COMPOBS  Comparison data set has observation not in base 
                           BASEBY   Base data set has BY group not in comparison 
                           COMPBY   Comparison data set has BY group not in base 
                           BASEVAR  Base data set has variable not in comparison 
                           COMPVAR  Comparison data set has variable not in base 
                           VALUE    A value comparison was unequal 
                           TYPE     Conflicting variable types 
                           BYVAR    BY variables do not match 
                           ERROR    Fatal error: comparison not done
   \param   i_id           optional: Id-column for matching of observations    
   \param   o_maxReportObs optional: number of observations that are copied from the expected and actual
                                     data set. default setting is MAX
   \return  ODS-document containing a comparison report; moreover, if o_maxReportObs ne 0, the expected and 
            the actual data set are written to testout
*/ /** \cond */ 

/* change history
   01.07.2008 AM  umfangreiche Überarbeitung:
                  i_allow eingeführt, um erlaubte Unterschiede steuern zu können, 
                  i_maxReportObs durch o_maxReportObs ersetzt
                  o_copydata eliminiert (Semantik o_copydata=0 durch o_maxReportObs=0 erreicht)
                  METHOD=ABSOLUTE eingesetzt, wenn i_fuzz gesetzt
*/ 

%MACRO assertColumns (
    i_expected     =      
   ,i_actual       =      
   ,i_desc         =      
   ,i_fuzz         =      
   ,i_allow        = DSLABEL LABEL COMPVAR
   ,i_id           =       
   ,o_maxReportObs = max
   ,i_maxReportObs =      /* obsolete */
);

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
%LOCAL l_i l_j l_symboli l_symbolj l_potenz l_mask; 
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
   %PUT &g_error: assertColumns: invalid symbol &l_symboli in parameter i_allow;
   %RETURN;
%label1:
   %LET l_mask = %sysfunc(bor(&l_mask, &l_potenz));
%END;

/*-- support obsolete parameter i_maxReportObs -------------------------------*/
%IF %length(&i_maxReportObs) %then %LET o_maxReportObs = &i_maxReportObs;

/*-- verify correct sequence of calls-----------------------------------------*/
%GLOBAL g_inTestcase;
%IF &g_inTestcase EQ 1 %THEN %DO;
   %endTestcall()
%END;
%ELSE %IF &g_inTestcase NE 2 %THEN %DO;
   %PUT &g_error: assert can only be called after initTestcase;
   %RETURN;
%END;

/*-- get current ids for test case and test --------- ------------------------*/
%LOCAL l_casid l_tstid;
%_sasunit_asserts(
    i_type     = assertColumns
   ,i_expected = %upcase(&i_allow)
   ,i_actual   = 
   ,i_desc     = &i_desc
   ,i_result   = .
   ,r_casid    = l_casid
   ,r_tstid    = l_tstid
)

/*-- check if actual dataset exists ------------------------------------------*/
%LOCAL l_rc l_actual; 
%IF NOT %sysfunc(exist(&i_actual,DATA)) AND NOT %sysfunc(exist(&i_actual,VIEW)) %THEN %DO;
   %LET l_rc=1;
   %LET l_actual=ERROR: actual table not found.;
%END;

/*-- check if expected dataset exists ----------------------------------------*/
%ELSE %IF NOT %sysfunc(exist(&i_expected,DATA)) AND NOT %sysfunc(exist(&i_expected,VIEW))%THEN %DO;
   %LET l_rc=1;
   %LET l_actual=&l_actual ERROR: expected table not found.;
%END;

/*-- compare tables ----------------------------------------------------------*/
%ELSE %DO;

   %LOCAL l_formchar l_compResult;
   %LET l_formchar=%sysfunc(getoption(formchar));
   OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

   ODS DOCUMENT NAME=testout._%substr(00&g_scnid,%length(&g_scnid))_&l_casid._&l_tstid._columns_rep(WRITE);
   TITLE;
   FOOTNOTE;
   PROC COMPARE
      BASE=&i_expected 
      COMPARE=&i_actual
      %IF %quote(&i_fuzz) NE %THEN CRITERION=&i_fuzz METHOD=ABSOLUTE;
      ;
      %IF %quote(&i_id) NE %THEN %str(ID &i_id;);
   RUN;
   %PUT sysinfo = &sysinfo;
   %LET l_compResult = &sysinfo;

   ODS DOCUMENT CLOSE;
   OPTIONS FORMCHAR="&l_formchar";

/*-- check proc compare result -----------------------------------------------*/
   %LET l_rc=%eval(%sysfunc(bxor(%sysfunc(bor(&l_mask,&l_compResult)),&l_mask)) NE 0);

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

%END; /* i_expected and i_actual exist */

/*-- update comparison result in test database -------------------------------*/
PROC SQL NOPRINT;
   UPDATE target.tst 
      SET 
          tst_res = &l_rc 
         ,tst_act = "&l_actual"
      WHERE 
         tst_scnid = &g_scnid AND
         tst_casid = &l_casid AND
         tst_id    = &l_tstid
      ;
QUIT;

/*-- write dataset sto the target area ---------------------------------------*/
%IF &o_maxreportobs NE 0 %THEN %DO;
   %IF %sysfunc(exist(&i_expected,DATA)) OR %sysfunc(exist(&i_expected,VIEW)) %THEN %DO;
      DATA testout._%substr(00&g_scnid,%length(&g_scnid))_&l_casid._&l_tstid._columns_exp;
         SET &i_expected (obs=&o_maxReportObs.);
      RUN;
   %END;

   %IF %sysfunc(exist(&i_actual,DATA)) OR %sysfunc(exist(&i_actual,VIEW)) %THEN %DO;
      DATA testout._%substr(00&g_scnid,%length(&g_scnid))_&l_casid._&l_tstid._columns_act;
         SET &i_actual (obs=&o_maxReportObs.);
      RUN;
   %END;
%END;

%MEND assertColumns;
/** \endcond */
