/**
   \file
   \ingroup    SASUNIT_SCN 

   \brief      Start of a new test case that comprises an invocation of
               a program under test and one or more assertions.

               Please refer to the description of the test tools in _sasunit_doc.sas. 

               internally: 
               - Insertion of relevant data into the test repository
               - Redirection of SAS log
               - Setting of flag g_inTestcase

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_object          source code file of program under test, is searched in 
                              the AUTOCALL path in case only the name of the source code 
                              file is given, without path information
   \param   i_desc            description of the test case
   \param   i_specdoc         optional: path of specification document
   \return
*/ /** \cond */ 

/* change log
   02.01.2013 KL To support LINUX as OS we need to convert pgm-names (macro names) to lowercase. Otherwise LINUX can't find the macro and assigns no pgm-library.
   09.02.2011 KL added two macro variables for re-redirecting log- and printfile in testcases
*/ 

%MACRO initTestcase(
   i_object   =  
  ,i_desc     =  
  ,i_specdoc  =  
);

%GLOBAL g_inTestcase;
%IF &g_inTestcase EQ 1 %THEN %DO;
   %endTestcall;
   %endTestcase;
%END;
%IF &g_inTestcase EQ 2 %THEN %DO;
   %endTestcase;
%END;
%LET g_inTestcase=1;

/* handle absolute and relative paths for programs */
%LOCAL l_pgm l_auton l_object;
%LET l_object = %lowcase (&i_object.);
%IF %index(%sysfunc(translate(&l_object,/,\)),/) %THEN %DO;
   %LET l_pgm = %_sasunit_stdPath(&g_root,&i_object);
   %LET l_auton=.;
%END;
%ELSE %DO;
   %LET l_pgm = &i_object;
   %LET l_auton = %_sasunit_getAutocallNumber(&l_object);
%END;

/* determine next test case id */
%LOCAL l_casid;%LET l_casid=0;
PROC SQL NOPRINT;
   SELECT max(cas_id) INTO :l_casid FROM target.cas
   WHERE cas_scnid = &g_scnid;
%IF &l_casid=. %THEN %LET l_casid=1;
%ELSE                %LET l_casid=%eval(&l_casid+1);
/* save metadata for this test case  */
   INSERT INTO target.cas VALUES (
       &g_scnid
      ,&l_casid
      ,&l_auton
      ,"&l_pgm"
      ,"&i_desc"
      ,"%_sasunit_abspath(&g_doc,&i_specdoc)"
      ,%sysfunc(datetime())
      ,.
      ,.
   );
QUIT;

%PUT ========================== test case &l_casid ======================================================;

/* reroute SASLOG and SASLIST */
%LET g_logfile  =&g_log/%sysfunc(putn(&g_scnid,z3.))_%sysfunc(putn(&l_casid,z3.)).log;
%LET g_printfile=&g_testout/%sysfunc(putn(&g_scnid,z3.))_%sysfunc(putn(&l_casid,z3.)).lst;
PROC PRINTTO 
   NEW 
   LOG="&g_logfile."
   PRINT="&g_printfile."
;
RUN;

%MEND initTestcase;
/** \endcond */
