/** 
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Utility  macro for the tests of SASUNIT - check  values in the test repository

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_tab        tsu, scn, cas or tst
   \param   i_col        column name without prefix
   \param   i_val        value
   \param   i_desc       optional: description of the tests
*/ /** \cond */ 

%macro assertDBValue(
    i_tab
   ,i_col
   ,i_val
   ,i_desc
);

%let i_val=%superq(i_val);

   proc sql noprint;
%let i_tab = %upcase(&i_tab);
%let i_col = %upcase(&i_col);

%local l_val;
      select &i_tab._&i_col into :l_val from target.&i_tab
         where  
%if &i_tab=SCN %then %do;
            scn_id = &scnid
%end;
%else %if &i_tab=CAS %then %do;
            cas_scnid = &scnid and
            cas_id = &casid
%end;
%else %if &i_tab=TST %then %do;
            tst_scnid = &scnid and
            tst_casid = &casid and
            tst_id = &tstid
%end;
      ;
quit;
%let l_val=%qtrim(%qleft(%superq(l_val)));

%if &i_desc= %then
   %let i_desc=&i_tab..&i_col = &i_val;

%assertEquals(i_expected=&i_val, i_actual=&l_val, i_desc=&i_desc)

%mend assertDBValue;
 
/** \endcond */
