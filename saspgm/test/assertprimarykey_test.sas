/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertPrimaryKey.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%initScenario(i_desc =Test of assertPrimaryKey.sas);

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
%initTestcase(
    i_object=assertPrimaryKey.sas
   ,i_desc=Tests with invalid parameters
   )
%endTestcall()

%assertPrimaryKey(i_desc=No parameters given);
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-1)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Library given%str(,) but no dataset
                 ,i_library=HUGO);
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-2)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Library and dataset given%str(,) but no variables
                 ,i_library=HUGO
                 ,i_dataset=Class
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-3)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Invalid Library is given
                 ,i_library=HUGO
                 ,i_dataset=Class
                 ,i_variables=Names age
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-4)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Invalid Dataset is given
                 ,i_library=sashelp
                 ,i_dataset=Class1
                 ,i_variables=Names age
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-5)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Empty string for parameter i_variables is given
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables= 
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-6)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Invalid Variablenames for i_Variables are given
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=Names age
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-7)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Invalid value for parameter maxReportObs is given %str(%()no number%str(%))
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=Name age
                 ,o_maxReportObs=ABC
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-8)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Invalid value for parameter maxReportObs is given %str(%()negative number%str(%))
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=Name age
                 ,o_maxReportObs=-4
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-9)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Empty string for parameter o_listingvars is given
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=Name age
                 ,o_listingvars=
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-10)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Invalid variablenames for o_listingvars are given
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=Name age
                 ,o_listingvars=Names age
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-11)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=Invalid value for parameter o_treatMissing
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=Name age
                 ,o_listingvars=Name age
                 ,o_treatMissings=UNALLOW
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-12)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertLog (i_errors=0, i_warnings=0);

%endTestcase;

/* test case 2 ------------------------------------ */
data work.class_missing;
   set sashelp.class;
   output;
   if (_N_=4) then do;
      name="";
      output;
   end;
   if (_N_=8) then do;
      age = .;
      output;
   end;
   if (_N_=12) then do;
      sex = "";
      output;
   end;
run;

%initTestcase(
    i_object=assertPrimaryKey.sas
   ,i_desc=Tests with valid parameters
   )
%endTestcall()

%assertPrimaryKey(i_desc=sashelp.class with key variables name
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=Name
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,1)
%assertDBValue(tst,res,0)

%assertPrimaryKey(i_desc=sashelp.class with key variables name age
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=Name age
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,1)
%assertDBValue(tst,res,0)

%assertPrimaryKey(i_desc=sashelp.class with key variables sex age
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=sex age
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,0)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=sashelp.class with key variables sex age%str(,) o_maxReportOBS: 8
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=sex age
                 ,o_maxReportObs=8
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,0)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=sashelp.class with key variables sex age%str(,) o_listingVars: Name Sex Age
                 ,i_library=sashelp
                 ,i_dataset=Class
                 ,i_variables=sex age
                 ,o_listingVars=Name Sex Age
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,0)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=sashelp.class with missing values for key variables%str(,) o_treatMissings: VALUE
                 ,i_library=work
                 ,i_dataset=class_missing
                 ,i_variables=Name Age
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,0)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=sashelp.class with missing values for key variables%str(,) o_treatMissings: VALUE
                 ,i_library=work
                 ,i_dataset=class_missing
                 ,i_variables=Name Sex Age
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,1)
%assertDBValue(tst,res,0)

%assertPrimaryKey(i_desc=sashelp.class with missing values for key variables%str(,) o_treatMissings: IGNORE
                 ,i_library=work
                 ,i_dataset=class_missing
                 ,i_variables=name age
                 ,o_treatMissings=ignore
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,0)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertPrimaryKey(i_desc=sashelp.class with missing values for key variables%str(,) o_treatMissings: IGNORE
                 ,i_library=work
                 ,i_dataset=class_missing
                 ,i_variables=name sex age
                 ,o_treatMissings=ignore
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,1)
%assertDBValue(tst,res,0)

%assertPrimaryKey(i_desc=sashelp.class with missing values for key variables%str(,) o_treatMissings: DISALLOW
                 ,i_library=work
                 ,i_dataset=class_missing
                 ,i_variables=name Age
                 ,o_treatMissings=disallow
                 );
%markTest()
%assertDBValue(tst,exp,1)
%assertDBValue(tst,act,-13)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertLog (i_errors=0, i_warnings=0);

proc delete data=work.class_missing;
run;

%endScenario();
/** \endcond */
