/** 
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Utility  macro for the tests of SASUNIT - Modify test result. If failed then OK else failed

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */

%macro assertMustFail(i_casid=_NONE_
                     ,i_tstid=_NONE_
                     );

   %local l_casid l_tstid l_tstres;

   %if (&i_tstid. = _NONE_ AND &i_casid. = _NONE_) %then %do;
      %_sasunit_getScenarioTestId (i_scnid=&g_scnid
                                  ,r_casid=l_casid
                                  ,r_tstid=l_tstid
                                  );
      %let l_tstid=%eval (&l_tstid.-1);
   %end;
   %else %do;
      %let l_tstid=&i_tstid.;
      %let l_casid=&i_casid.;
   %end;

   proc sql noprint;
      select tst_res into :l_tstres from target.tst
         where  
            tst_scnid = &g_scnid.
            AND tst_casid = &l_casid.
            AND tst_id = &l_tstid.;
   quit;

   %if (&l_tstres. = 2) %then %do;
      %let l_tstres=0;
   %end;
   %else %do;
      %let l_tstres=2;
   %end;
   
   proc sql noprint;
      update target.tst
      set tst_res=&l_tstres.
         where  
            tst_scnid = &g_scnid.
            AND tst_casid = &l_casid.
            AND tst_id = &l_tstid.;
   quit;
%mend assertMustFail;
 
/** \endcond */
