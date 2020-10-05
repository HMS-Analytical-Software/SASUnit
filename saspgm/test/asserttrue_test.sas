/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertTrue.sas 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 
%initScenario(i_desc =Test of assertTrue.sas);

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
%initTestcase(i_object   =assertTrue.sas
             ,i_desc     =Tests with invalid input parameters
             );
             
%endTestcall()

   %assertTrue (i_cond =         
               ,i_desc = Call without condition
               );              
               
   %markTest()
      %assertDBValue(tst,exp, true)
      %assertDBValue(tst,act, )
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
      
   %assertLog (i_errors=0, i_warnings=0);

%endTestcase();
   
/* test case 2 ------------------------------------ */

%initTestcase(i_object   =assertText.sas
             ,i_desc     =Successfull tests
             )
%endTestcall()

   %assertTrue (i_cond = FaLsE
               ,i_desc = Call with text FaLsE as condition
               );              
   %markTest()
      %assertDBValue(tst,exp,true)
      %assertDBValue(tst,act,false)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

   %assertTrue (i_cond = TrUe
               ,i_desc = Call with text TrUe as condition
               );              
   %markTest()
      %assertDBValue(tst,exp,true)
      %assertDBValue(tst,act,true)
      %assertDBValue(tst,res,0)

   %assertTrue (i_cond = AbC
               ,i_desc = Call with simple string as condition
               );              
   %markTest()
      %assertDBValue(tst,exp,true)
      %assertDBValue(tst,act,AbC)
      %assertDBValue(tst,res,0)

   %assertTrue (i_cond = 123
               ,i_desc = Call with number as condition
               );              
   %markTest()
      %assertDBValue(tst,exp,1)
      %assertDBValue(tst,act,123)
      %assertDBValue(tst,res,0)
      
   %assertTrue (i_cond = %eval(3-3)
               ,i_desc = Call with numeric expression as condition -> false
               );              
   %markTest()
      %assertDBValue(tst,exp,1)
      %assertDBValue(tst,act,0)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
      
   %assertTrue (i_cond = %eval(3+3)
               ,i_desc = Call with numeric expression as condition -> true
               );              
   %markTest()
      %assertDBValue(tst,exp,1)
      %assertDBValue(tst,act,6)
      %assertDBValue(tst,res,0)
      
   %assertTrue (i_cond = %sysevalf(ABC=ABC)
               ,i_desc = Call with character expression as condition -> true
               );              
   %markTest()
      %assertDBValue(tst,exp,1)
      %assertDBValue(tst,act,1)
      %assertDBValue(tst,res,0)
      
   %assertTrue (i_cond = %sysevalf(ABC=ABCD)
               ,i_desc = Call with character expression as condition -> false
               );                            
   %markTest()
      %assertDBValue(tst,exp,1)
      %assertDBValue(tst,act,0)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

   %assertTrue (i_cond = %sysfunc(exist(sashelp.class))
               ,i_desc = Call with sysfunc exist expression as condition -> true
               );              
   %markTest()
      %assertDBValue(tst,exp,1)
      %assertDBValue(tst,act,1)
      %assertDBValue(tst,res,0)
      
   %assertTrue (i_cond = %sysfunc(exist(sashelp._class1))
               ,i_desc = Call with sysfunc exist expression as condition -> false
               );                            
   %markTest()
      %assertDBValue(tst,exp,1)
      %assertDBValue(tst,act,0)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertLog (i_errors=0, i_warnings=0);
%endTestcase();

%endScenario();
/** \endcond */