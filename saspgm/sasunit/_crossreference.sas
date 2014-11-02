/** \file
   \ingroup    SASUNIT_UTIL
   \brief      The macro allows to gather cross reference information between different macros. A calling
               hierarchy is established for the directories found in the test database in columns 
               tsu_sasautos1 to tsu_sasautos9. If i_includeSASUnit is set to 1 the directories in tsu_sasunit, 
               tsu_sasunit_os and tsu_sasautos are included as well in the scan.
               Libref target has to be set.

   \version    \$Revision: 282 $
   \author     \$Author: klandwich $
   \date       \$Date: 2013-11-21 11:32:48 +0100 (DO, 21 Nov 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/windows/_dir.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
               
   \param      i_includeSASUnit  Include the SASUnit core macros in scan or not, default set to 0
   \param      i_examinee        Data set containing content of autocall libraries 
   \param      i_listcalling     Data set with columns caller and called representing the calling hierarchy
   \param      i_dependency      Data set holding results of this macro needed in macro _checkScenario
   \param      i_macroList       Data set with list of all macros, needed for visualization of calling hierarchy
   
   */ /** \cond */ 

%MACRO _crossreference(i_includeSASUnit  =0
                      ,i_examinee        =
                      ,i_listcalling     =
                      ,i_dependency      =
                      ,i_macroList       =
                      );

   %LOCAL l_callVar
          l_DoxyHeader
          l_filename
          l_includeSASUnit
          l_loop
          l_mprint
          l_nobs
          l_notes
          l_path
          l_sasunit 
          l_source
          l_path1
          l_path2
          n
          nobs
          nobs_old;
   
   %IF &g_verbose =0 %THEN %DO;
      %let l_source =%sysfunc(getoption(source));
      %let l_notes  =%sysfunc(getoption(notes));
      %let l_mprint =%sysfunc(getoption(mprint));
      
      options nomprint nonotes nosource;
   %END;

   /* Decide which macros to scan: 1 = all macros, 0 = skip SASUnit macros */
   %IF &i_includeSASUnit ne 0 %THEN %LET l_includeSASUnit=1;
   %ELSE %LET l_includeSASUnit=0;
   
   /* Keep all .sas files and get macro names*/
   DATA &i_macroList;
      length name $ 80;
      SET &i_examinee.;
      IF index(filename,'.sas') = 0 THEN delete;
      loca = length(filename) - length(scan(filename,-1,'/')) + 1;
      name = substr(filename,loca);
      name = substr(name, 1, length(name)-4);
      drop loca changed;
   RUN;
   
   PROC SORT DATA=&i_macroList NODUPKEY;
      BY membername;
   RUN;

   /* Generate macro variable with name of each macro in &i_macroList */
   Data &i_macroList;
      IF _N_ = 1 THEN DO;
         i=0;
      END;
      SET &i_macroList end=eof;
      Call Symputx(catt("var",i), name);
      Call Symputx('l_name',name);
  
      IF eof THEN Call Symputx("l_count",i);
      i+1;
   RUN;

   /* Generate result data set */
   DATA &i_listcalling;
      length caller called $ 80
             line $ 256;
      STOP;
   RUN;

   /* l_includeSASUnit = 1: include sasunit macros in scan   */
   %IF &l_includeSASUnit = 0 %THEN %DO;
      PROC SQL noprint;
         select tsu_sasunit_os into: l_sasunit_os
         from target.tsu
      ;
      QUIT;
      
      %LET l_path1 = %_abspath(&g_root,&g_sasunit)/%;
      %LET l_path2 = %_abspath(&g_root,&l_sasunit_os)/%;
   
      DATA &i_macroList;
         SET &i_macroList(WHERE=(filename not like "&l_path1" AND filename not like "&l_path2"));
      RUN;
   %END;
 
   /* Loop over macros to find references*/
   %LET l_loop = 1;
   %DO %WHILE (&l_loop);
      %LET l_loop = 0;

      Data &i_macroList;
         Modify &i_macroList(Where=(filename NE ''));
         Call Symputx('l_filename',filename);
         Call Symputx('l_name',name);
         Call Symputx('l_loop' ,1);
         filename ='';
         Replace;
         STOP;
      RUN;

      %IF &l_loop %THEN %DO;

         /* Find all macro calls in a macro */
         DATA helper;
            IF _N_ = 1 THEN DO;
               retain pattern1 ptrn_Com_1_o ptrn_Com_1_c;
               retain l_DoxyHeader 0 comment 0;
               length line $ 256
                      caller called $ 80;
               pattern1 = prxparse('/%/');
               ptrn_Com_1_o = prxparse('/\/\*/');
               ptrn_Com_1_c = prxparse('/\*\//');
            END;

            INFILE "&l_filename" truncover;
            INPUT line;
            line = trim(left(_infile_));

            /* Scan for comment: IF found delete it */
            fnt_o = prxmatch(ptrn_Com_1_o, line);
            /* Begin of comment found */
            IF fnt_o > 0 and comment = 0 THEN DO;
               fnt_c = prxmatch(ptrn_Com_1_c, line);
               /* Comment closed on same line */
               IF fnt_c > 0 THEN DO;
                  IF fnt_o = 1 THEN line = substr(line, fnt_c+2);
                  ELSE line = catt(substr(line,1,fnt_o-1), substr(line, fnt_c+2));
                  comment=0;
               END;
               /* Comment not closed on same line */
               ELSE IF fnt_c = 0 THEN DO;
                  IF fnt_o = 1 THEN line = "";
                  ELSE line = substr(line,1,fnt_o-1);
                  comment = 1;
               END;
            END;
            /* Line following an opened comment */
            ELSE IF comment = 1 THEN DO;
               fnt_c = prxmatch(ptrn_Com_1_c, line);
               /* Comment not closed on line */
               IF fnt_c = 0 THEN line = "";
               ELSE DO;
                  line = substr(line, fnt_c+2);
                  comment = 0;
               END;
            END;

            /* '%' found in line: look for macro call */
            IF prxmatch(pattern1, line) THEN DO;
               DO x=0 to &l_count;
                  called      = resolve(catt('&var',x));
                  calledMacro = catt('%',called);
                  findpos = find(line, trim(calledMacro), 'i');
                  /* candidate found */
                  IF findpos gt 0 THEN DO;
                     len = length(trim(calledMacro));
                     /* make sure found string is whole macro name and not only a substring */
                     substring = substr(line, findpos+len,1);
                     IF substring in ('(',' ',';')  THEN DO;
                        caller = resolve("&l_name");
                        KEEP line caller called;
                        OUTPUT;
                     END;
                  END;
               END;
            END;
         RUN;
         
         DATA _NULL_;
            SET helper nobs=cnt_obs;
            call symput('l_nobs', put(cnt_obs, 4.));
         RUN;
         
         %IF &l_nobs GT 0 %THEN %DO;
            /* Neglect multiple calls to the same macro */
            PROC sort DATA = helper nodupkey;
               BY called;
            RUN;
            /* Append data from helper to calling macro-data set */     
            PROC append base=&i_listcalling DATA=helper;
               where caller ne called;
            RUN;
         %END;
      %END; /* %IF &l_loop %THEN %DO */
   %END;/* Loop over macros to find references*/

   /* Use results from scan to build hierarchy*/
   PROC SQL noprint;
      create table stage1 as
      select distinct caller, called
      from &i_listcalling as l1
      ;
      select count(caller) into: nobs
      from stage1
      ;
   QUIT;

   %LET n = 1;
   %LET l_loop = 1;

   /* Iterate over stageX data sets till no more observations are appended and all
     dependencies are found */
   %DO %while (&l_loop);
      %LET nobs_old = &nobs.;
      %LET n = %eval(&n. + 1);

      proc sql noprint;
         create table stage&n. as
         select distinct s.caller, l.called
         from stage%eval(&n.-1) as s
         join &i_listcalling. as l
         on s.called = l.caller
         ;
      quit;
      data stage&n.;
         set stage&n. stage%eval(&n.-1);
      run;
      proc sort data=stage&n. noduplicate;
         by caller called;
      run;
      PROC SQL noprint;
         select count(caller) into: nobs
         from stage&n.
         ;
      QUIT;
      %IF &nobs eq &nobs_old %THEN %LET l_loop=0;
   %END;
/*
   data _stages;
      length all_called $32000;
      set stage&n.;
      retain all_called "";
      by caller;
      if first.caller then do;
         all_called=called;
      end;
      if not first.caller then do;
         all_called = catt (all_called, ',', called);
      end;
      if (last.caller);
   run;
   proc sql noprint;
      create table _caller as
         select t.all_called, s.*
         from stage1 as s left join _stages as t 
         on s.called=t.caller
         order by s.caller;
   quit;
   data stage&n.;
      length caller $32000;
      set _caller;
      drop all_called;
      if (not missing(all_called)) then do;
         called = catt (called, ',', all_called);
      end;
   run;

   /* Get dependency information for scenarios and all called macros */
   DATA &i_dependency;
      SET stage&n.;
      keep caller calledByCaller;
      caller = catt(caller,".sas");
      cnt = count(called,',');
      DO i=1 TO cnt+1;
         calledByCaller = catt(scan(called,i,','),".sas");
         OUTPUT; 
      END;
   RUN;
   
   PROC SORT DATA=&i_dependency NODUPKEY;
      BY caller calledByCaller;
   RUN;
   
   %IF &g_verbose =0 %THEN %DO;
      options &l_source &l_notes &l_mprint;
   %END;
%MEND _crossreference;
/** \endcond */
