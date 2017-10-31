/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertForeignKey.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%initScenario(i_desc =Test of assertForeignKey.sas);

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
%initTestcase(
    i_object=assertForeignKey.sas
   ,i_desc=Tests with invalid parameters
   )
%endTestcall()
PROC SQL;
  create table test1 as
  SELECT distinct sex
  FROM sashelp.class
  ;
QUIT;

data test2;
   input sex;
datalines;
1
2
;
run;

data test8;
   set sashelp.class (keep = name age);
   if name = "Jane" then name="";
run;

data test9;
   set sashelp.class (obs = 10);
   if name = "Jane" then name="";
run;

%assertForeignKey(i_mstrLib=hugo,    i_mstMem=class,  i_mstKey=sex,     i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=sex,      i_desc=Invalid master table library);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-1)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=hugo,   i_mstKey=sex,     i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=sex,      i_desc=Invalid master table member name);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-1)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex,     i_lookupLib=hugo, i_lookupMem=test1,   i_lookupKey=sex,      i_desc=Invalid lookup table library);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-2)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex,     i_lookupLib=work, i_lookupMem=hugo,    i_lookupKey=sex,      i_desc=Invalid lookup table member name);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-2)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex hugo,i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=sex,      i_desc=Number of keys specified for master table not equal to number of keys given);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-3)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex,     i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=sex hugo, i_desc=Number of keys specified for lookup table not equal to number of keys given);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-4)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex,     i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=sex,      i_desc=Invalid parameter for maxObsRprtFail,                                 o_maxObsRprtFail= hugo);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-19)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex,     i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=sex,      i_desc=Invalid parameter for maxObsRprtFail,                                 o_maxObsRprtFail= -5);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-20)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex,     i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=sex,      i_desc=Invalid parameter l_listingVars: Column not found in master data set, o_listingVars=cars);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-21)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex,     i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=sex,      i_desc=Test with invalid parameter treatMissingsMst,                          o_treatMissings=hugo);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-22)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=work,    i_mstMem=test8,  i_mstKey=name,    i_lookupLib=sashelp, i_lookupMem=class,i_lookupKey=name,     i_desc=Test with treatMissingsMst=dissalow and missing key values in master data set, o_treatMissings=DISALLOW);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-23)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=hugo,    i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=sex,      i_desc=Key specified in i_mstKey not found in master table);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-5)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex,     i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=hugo,     i_desc=Key specified in i_lookupKey not found in lookup table);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-6)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex,     i_lookupLib=work, i_lookupMem=test2,   i_lookupKey=sex,      i_desc=Specified keys for tables with incompatible data type);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-7)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex,     i_lookupLib=work, i_lookupMem=test1,   i_lookupKey=sex,      i_desc=Invalid parameter i_unique hugo,  i_unique=hugo);
   %markTest()
      %assertDBValue(tst,exp,HUGO)
      %assertDBValue(tst,act,-24)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertLog (i_errors=0, i_warnings=0)
%endTestcase();

/* test case 2 ------------------------------------ */
%initTestcase(
    i_object=assertForeignKey.sas
   ,i_desc=Key of lookup table not unique
)
%endTestcall()
data work.test3;
   length sex $ 1;
   input sex $;
datalines;
F
M
M
;
run;
data work.test4;
   length sex $ 1;
   input sex $;
datalines;
F
A
;
run;
PROC SQL;
  create table test7 as
  SELECT distinct name, sex, age
  FROM sashelp.class
  where sex="F"
  ;
QUIT;
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=sex, i_lookupLib=work, i_lookupMem=test3, i_lookupKey=sex, i_desc=Parameter i_unique set to true but column sex in lookup table test3 non unique);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,-8)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class,  i_mstKey=name,i_lookupLib=work, i_lookupMem=test7, i_lookupKey=name,  i_desc=test with o_maxObsRprtFail %str(=) 5, o_maxObsRprtFail = 5);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,10)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertForeignKey(i_mstrLib=work,    i_mstMem=test9,  i_mstKey=name,i_lookupLib=work, i_lookupMem=test7, i_lookupKey=name,  i_desc=test with listingVars %str(=) age, o_listingVars=age);
   %markTest()
      %assertDBValue(tst,exp,TRUE)
      %assertDBValue(tst,act,6)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertLog (i_errors=0, i_warnings=0)
%endTestcase();

/* test case 3 ------------------------------------ */
%initTestcase(
    i_object=assertForeignKey.sas
   ,i_desc=Successful tests
)
%endTestcall()

PROC SQL;
  create table test5 as
  SELECT distinct sex, age
  FROM sashelp.class
  ;
QUIT;

%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class, i_mstKey=sex age, i_lookupLib=work, i_lookupMem=test5, i_lookupKey=sex age, i_desc=Test with composite key, i_cmpKeyLen=2);

PROC SQL;
  create table test6  (RENAME=(sex=gender age=years))  as
  SELECT distinct sex, age
  FROM sashelp.class
  ;
QUIT;
%assertForeignKey(i_mstrLib=sashelp, i_mstMem=class, i_mstKey=sex age, i_lookupLib=work, i_lookupMem=test6, i_lookupKey=gender years, i_desc=Renaming of column names, i_cmpKeyLen=2);


PROC SQL;
  create table test10 as
  SELECT distinct name, sex, age
  FROM sashelp.class
  where age > 14
  ;
QUIT;
%assertForeignKey(i_mstrLib=work,   i_mstMem=test7, i_mstKey=name,i_lookupLib=sashelp, i_lookupMem=class, i_lookupKey=name, i_desc=test with listingVars %str(=) age,                                               o_listingVars=age);
%assertForeignKey(i_mstrLib=work,   i_mstMem=test8, i_mstKey=name,i_lookupLib=sashelp, i_lookupMem=class, i_lookupKey=name, i_desc=Test with treatMissings=ignore and missing key values in master data set,        o_treatMissings=ignore);
%assertForeignKey(i_mstrLib=work,   i_mstMem=test9, i_mstKey=name,i_lookupLib=work,    i_lookupMem=test8, i_lookupKey=name, i_desc=treat missing values in master table like any other value,                       o_treatMissings=VALUE);
%assertForeignKey(i_mstrLib=sashelp,i_mstMem=class, i_mstKey=sex, i_lookupLib=work,    i_lookupMem=test3, i_lookupKey=sex,  i_desc=Column sex in lookup table test3 non unique and parameter i_unique set to false, i_unique=false);
%assertForeignKey(i_mstrLib=work,   i_mstMem=test7, i_mstKey=name,i_lookupLib=sashelp, i_lookupMem=class, i_lookupKey=name, i_desc=test with i_unique %str(=) false%str(,) but lookup table is unique,              i_unique=false);
%assertLog (i_errors=0, i_warnings=0)
%endTestcase();

proc datasets lib=work nolist;
   delete 
      test1 test2 test3 test4 test5 test6 test7 test8 test9 test10
   ;
run;
quit;

%endScenario();
/** \endcond */
