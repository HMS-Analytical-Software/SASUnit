/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertTableExists.sas - has to fail!

   \version    \$Revision: 190 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-05-29 18:04:27 +0200 (Mi, 29 Mai 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/asserttableexists_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
libname hugo1 "X:/TEST";;

%initTestcase(
    i_object=assertTableExists.sas
   ,i_desc=call with invalid library - must be red!
	)
	data hugo.class;
		 set sashelp.class;
	run;
%endTestcall()

%assertTableExists(i_libref=hugo,  i_memname=class, i_desc=Libref is invalid - must be red!, i_not=0);
	%markTest()
		%assertDBValue(tst,exp,DATA:hugo.class:0)
		%assertDBValue(tst,act,-1)
		%assertDBValue(tst,res,2)
		%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertTableExists(i_libref=hugo1, i_memname=class, i_desc=Libref is invalid - must be red!, i_not=0);
	%markTest()
		%assertDBValue(tst,exp,DATA:hugo1.class:0)
		%assertDBValue(tst,act,-1)
		%assertDBValue(tst,res,2)
		%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertTableExists(i_libref=hugo1, i_memname=class, i_desc=Libref is invalid (negated), i_not=1);
	%markTest()
		%assertDBValue(tst,exp,DATA:hugo1.class:1)
		%assertDBValue(tst,act,-1)
		%assertDBValue(tst,res,2)
		%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertLog (i_errors=1, i_warnings=0)
%endTestcase();

/* test case 2 ------------------------------------ */
%initTestcase(
    i_object=assertTableExists.sas
   ,i_desc=call with invalid i_target - must be red!
)
%endTestcall()
	data class;
		 set sashelp.class;
	run;

%assertTableExists(i_libref=work,  i_memname=class, i_target=DATA, i_desc=%str(Libref is valid. i_target not in Data, View or Catalog), i_not=0);
%assertTableExists(i_libref=sashelp, i_memname=class, i_target=Hugo, i_desc=%str(Libref is valid. i_target not in Data, View or Catalog - must be red!), i_not=0);
	%markTest()
	%assertDBValue(tst,exp,HUGO:sashelp.class:0)
	%assertDBValue(tst,act,-2)
	%assertDBValue(tst,res,2)
	%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertTableExists(i_libref=sashelp, i_memname=class, i_target=VIEW, i_desc=Libref is valid. Wrong i_target - must be red!, i_not=0);
	%markTest()
	%assertDBValue(tst,exp,VIEW:sashelp.class:0)
	%assertDBValue(tst,act,0)
	%assertDBValue(tst,res,2)
	%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertTableExists(i_libref=sashelp, i_memname=class, i_target=CATALOG, i_desc=Libref is valid. Wrong i_target - must be red!, i_not=0);
	%markTest()
	%assertDBValue(tst,exp,CATALOG:sashelp.class:0)
	%assertDBValue(tst,act,0)
	%assertDBValue(tst,res,2)
	%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertTableExists(i_libref=sashelp, i_memname=class, i_target=CATALOG, i_desc=Libref is valid. Wrong i_target (negated), i_not=1);
%assertLog (i_errors=0, i_warnings=0)
%endTestcase();

/* test case 3 ------------------------------------ */
libname hugo (WORK);
%initTestcase(
    i_object=assertTableExists.sas
   ,i_desc=call with valid library and data set - must be red!
)
	data hugo.class;
		 set sashelp.class;
	run;
	data hugo.Vview;
		set sashelp.Vview;
	run;
%endTestcall()

%assertTableExists (i_libref=hugo, i_memname=class,  i_desc=Libref is valid. Dataset exists., i_not=0);
%assertTableExists (i_libref=hugo, i_memname=Vview , i_target=view, i_desc=Libref is valid. View does exist - must be red!, i_not=0);
	%markTest()
	%assertDBValue(tst,exp,VIEW:hugo.Vview:0)
	%assertDBValue(tst,act,0)
	%assertDBValue(tst,res,2)
	%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertTableExists (i_libref=hugo, i_memname=class,  i_desc=Libref is valid. Dataset exists (negated) - must be red!, i_not=1);
	%markTest()
	%assertDBValue(tst,exp,DATA:hugo.class:1);
						proc sql noprint;
										select scan (tst_act,1,"#") into :_actval from target.tst
											 where
													tst_scnid = &g_scnid and
													tst_casid = &casid and
													tst_id = &tstid
										;
						quit;
	%assertequals(i_expected=1,i_actual=&_actval.,i_desc=%str(TST.ACT='1'));
	%assertDBValue(tst,res,2)
	%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertTableExists (i_libref=hugo, i_memname=class1, i_desc=Libref is valid. Dataset does not exist (negated)., i_not=1);

%assertLog (i_errors=0, i_warnings=0)

%endTestcase();

/* test case 4 ------------------------------------ */
libname hugo (WORK);
%initTestcase(
    i_object=assertTableExists.sas
   ,i_desc=call with valid library and view - must be red!
)
	data hugo.class_V / view=hugo.class_V;
		 set sashelp.class;
	run;
%endTestcall()

%assertTableExists (i_libref=hugo, i_memname=class_V, i_target=view, i_desc=Libref is valid. Dataset exists., i_not=0);
%assertTableExists (i_libref=hugo, i_memname=class_B, i_target=view, i_desc=Libref is valid. Dataset does not exist - must be red!, i_not=0);
	%markTest()
	%assertDBValue(tst,exp,VIEW:hugo.class_B:0)
	%assertDBValue(tst,act,0)
	%assertDBValue(tst,res,2)
	%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertTableExists (i_libref=hugo, i_memname=class_V, i_target=view, i_desc=Libref is valid. Dataset exists (negated) - must be red!, i_not=1);
	%markTest()
	%assertDBValue(tst,exp,VIEW:hugo.class_V:1);
						proc sql noprint;
										select scan (tst_act,1,"#") into :_actval from target.tst
											 where
													tst_scnid = &g_scnid and
													tst_casid = &casid and
													tst_id = &tstid
										;
						quit;

	%assertequals(i_expected=1,i_actual=&_actval.,i_desc=%str(TST.ACT='1'));
	%assertDBValue(tst,res,2)
	%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%assertTableExists (i_libref=hugo, i_memname=class_B, i_target=view, i_desc=Libref is valid. Dataset does not exist (negated)., i_not=1);

%assertLog (i_errors=0, i_warnings=0)

%endTestcase();

/** \endcond */
