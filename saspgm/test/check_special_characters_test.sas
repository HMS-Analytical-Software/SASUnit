/**
   \file
   \ingroup    SASUNIT_TEST 
   \brief      Tests for calls to macros including special characters as parameter
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

%initScenario(i_desc =Tests for calls to macros including special characters as parameter);

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/*-- first call: Everthing is ok ------------------------------------*/
%initTestcase(i_object=_dummy_macro.sas, i_desc=no special characters anywhere)
%endTestcall()
%assertLog(i_errors=0, i_warnings=0, i_desc=everything is OK)
%assertEquals(i_actual=No special characters anywhere, i_expected=No special characters anywhere, i_desc=no special characters anywhere)
%endTestcase()

/*-- Second call: Special characters in i_desc for assertLog,assertLogMsg and assertEquals  ------------------------------------*/
%initTestcase(i_object=_dummy_macro.sas, i_desc=%str(special characters without comma, brackets and apostrophe))
%_dummy_macro (i_desc=i_desc contains special characters like & - < > \ {} [] % § and &%str(amp;) as well as &%str(hugo;))
%endTestcall()
%assertLog(i_errors=0, i_warnings=0, i_desc=i_desc contains special characters like & - \ < > % and %str(&amp;) as well as &%str(hugo;))
%assertLog(i_errors=0, i_warnings=0, i_desc=%nrstr(i_desc contains special characters like & - ()%) {} [] § \ < > % and &amp; as well as &hugo;))
%assertEquals(i_actual=10, i_expected=10, i_desc=i_desc contains special characters like & - \ < > % and %str(&amp;) as well as &%str(hugo;))
%assertEquals(i_actual=10, i_expected=10, i_desc=%nrstr(i_desc contains special characters like & - ()%) {} [] § \ < > % and &amp; as well as &hugo;))
%assertLogMsg(i_logmsg= %nrstr(i_desc contains special characters like) , i_desc=Scan for log message )
%assertLogMsg(i_logmsg= %nrstr(i_desc contains special characters like & - < > ) , i_desc=Scan for log message )
%assertLogMsg(i_logmsg= &.str\(amp;\) , i_desc=%nrstr(Scan for log message: Escaping a "("))
%assertLogMsg(i_logmsg= %nrstr(% § and &amp\; as well as &hugo;) , i_desc=%nrstr(Scan for log message: Escaping a ";") )
%assertLogMsg(i_logmsg= \{\} \[\], i_desc=Scan for log message )
%endTestcase()

/*-- Third call: Special characters in html   ------------------------------------*/
%initTestcase(i_object=_dummy_macro.sas, i_desc=special characters in html)
%_dummy_macro (i_desc=i_desc contains  special html characters such as &%str(rsquo;) &%str(rdquo;) &%str(#41;) &%str(lt;))
%endTestcall()
%assertLog(i_errors=0, i_warnings=0, i_desc= %str(%"))
%assertLog(i_errors=0, i_warnings=0, i_desc= i_desc contains  special html characters such as &%str(rsquo;) &%str(rdquo;) &%str(#41;) &%str(lt;))
%assertLog(i_errors=0, i_warnings=0, i_desc= i_desc contains  special html characters such as &rsquo; &rdquo; &#41; &lt;)
%assertEquals(i_actual=10, i_expected=10, i_desc=i_desc contains  special html characters such as &%str(rsquo;) &%str(rdquo;) &%str(#41;) &%str(lt;))
%assertEquals(i_actual=10, i_expected=10, i_desc=i_desc contains  special html characters such as &rsquo; &rdquo; &#41; &lt;)
%endTestcase()

/*-- Fourth call: SASUnit macros  ------------------------------------*/
%initTestcase(i_object=_dummy_macro.sas, i_desc=%str(SASUnit macros - masked for passing))
%_dummy_macro (i_desc=i_desc contains  SASUnit macros such as %nrstr(%endTestcall()) and %nrstr(%endTestcase()))
%endTestcall()
%assertLog(i_errors=0, i_warnings=0, i_desc=%nrstr(i_desc contains SASUnit macros such as %nrstr(%endTestcall()) and %nrstr(%endTestcase())))
%assertEquals(i_actual=10, i_expected=10, i_desc=%nrstr(i_desc contains SASUnit macros such as %nrstr(%endTestcall()), %nrstr(%endTestcase()))) /* Komma nicht maskiert*/
%assertLog(i_errors=0, i_warnings=0, i_desc=%nrstr(i_desc contains SASUnit macros such as %%nrstr%(%%endTestcall%(%)%) and %%nrstr%(%%endTestcase%(%)%)))
%assertEquals(i_actual=10, i_expected=10, i_desc=%nrstr(i_desc contains SASUnit macros such as %%nrstr%(%%endTestcall%(%)%) and %%nrstr%(%%endTestcase%(%)%))) 
%endTestcase()

/*-- Fifth call: Macro instructions  ------------------------------------*/
%initTestcase(i_object=_dummy_macro.sas, i_desc= SAS macro instructions)
%_dummy_macro (i_desc=%nrstr(i_desc contains macro instructions such as %%local and %%let ))
%endTestcall()
%assertEquals(i_actual=0, i_expected=0, i_desc=%nrstr(i_desc contains macro instructions such as %%nrstr%(%%local%), %%nrstr%(%%let%) ))
%assertLog(i_errors=0, i_warnings=0, i_desc=%nrstr(i_desc contains macro instructions such as %%nrstr%(%%local%), %%nrstr%(%%let%) ))
%endTestcase()

/*-- Sixth call: Special characters in i_desc for dummy macro  ------------------------------------*/
%initTestcase(i_object=_dummy_macro.sas, i_desc=%str(special characters without comma, brackets and apostrophe - must be red!))
%_dummy_macro (i_desc=%nrstr(i_desc contains special characters like & - ()%) {} [] § \ < > % and &amp; as well as &hugo;))
%endTestcall()
%assertEquals(i_actual=%nrstr(& - ()%) {})                  ,i_expected=%nrstr(& - ()%) {})       ,i_desc=Special characters in i_actual and i_expected)
%assertEquals(i_actual=&amp;                                ,i_expected=&amp;                     ,i_desc=Special characters in i_actual and i_expected)
%assertEquals(i_actual=& - \                                ,i_expected=& - \                     ,i_desc=Special characters in i_actual and i_expected)
%assertEquals(i_actual= %nrstr(§ \ < > % and &amp; as well as &hugo;), i_expected= %nrstr(§ \ < > % and &amp; as well as &hugo;) , i_desc=Special characters in i_actual and i_expected)
%assertEquals(i_actual=Special characters                   ,i_expected=Special characters        ,i_desc=Special characters in i_actual and i_expected)

%let testfile1 = class.jpg;
%assertReport(i_actual=&g_refdata./class.jpg                ,i_expected=&g_refdata./&testfile1    ,i_desc=No Special characters in file name)
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,No Special characters in file name)
%assertDBValue(tst,exp,.jpg)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_actual=&g_refdata./%nrstr(class.jpg)        ,i_expected=&g_refdata./&testfile1    ,i_desc=No Special characters)
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,No Special characters)
%assertDBValue(tst,exp,.jpg)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

/* Does not run under LINUX in conjunction with %str(*) 
%assertReport(i_actual=&g_refdata./%nrstr(file%%dh%(.xlsx)  ,i_expected=&g_refdata./%nrstr(file%%dh%(.xlsx)     ,i_desc=Special characters in file name - must be red!)
*/

%assertReport(i_actual=&g_refdata./%nrstr(file-to_$8.xlsx)  ,i_expected=&g_refdata./%nrstr(file-to_$8.xlsx)     ,i_desc=Special characters in file name)
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,Special characters in file name)
%assertDBValue(tst,exp,.xlsx)
%assertDBValue(tst,act,.xlsx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase()
