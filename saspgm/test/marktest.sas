/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Utility macro for the tests of SASUNIT - memorize the ids of the last assertions;
               the ids are output with three digits and leading zeros

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */

%macro markTest();

%global casid tstid;

proc sql noprint;
   select max(tst_casid) into :casid
      from target.tst
      where tst_scnid=&g_scnid;
   select max(tst_id) into :tstid 
      from target.tst
      where tst_scnid=&g_scnid and tst_casid=&casid;
quit;
%let casid = &casid;
%let casid = %substr(00&casid,%length(&casid));
%let tstid = &tstid;
%let tstid = %substr(00&tstid,%length(&tstid));

%mend markTest;
 
/** \endcond */
