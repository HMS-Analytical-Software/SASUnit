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
   \param      i_examinee        Name of data set containing content of autocall libraries 

*/ /** \cond */ 

%MACRO _crossreference(i_includeSASUnit  =0
                      ,i_examinee        =
                      );

   %LOCAL l_callVar
          l_cattVar
          l_cattVarLen
          l_DoxyHeader
          l_filename
          l_includeSASUnit
          l_loop
          l_nobs
          l_path
          l_sasunit 
          l_source
          l_path1
          l_path2
          n
          nobs
          nobs_old;
   
   %IF &g_verbose =0 %THEN %DO;
      %let source =%sysfunc(getoption(source));
      %let notes  =%sysfunc(getoption(notes));
      %let mprint =%sysfunc(getoption(mprint));
      
      options nomprint nonotes nosource;
   %END;

   /* Decide which macros to scan: 1 = all macros, 0 = skip SASUnit macros */
   %IF &i_includeSASUnit ne 0 %THEN %LET l_includeSASUnit=1;
   %ELSE %LET l_includeSASUnit=0;
   
   /* Keep all .sas files and get macro names*/
   DATA dir;
      length name $ 80;
      SET &i_examinee.;
      IF index(filename,'.sas') = 0 THEN delete;
      loca = length(filename) - length(scan(filename,-1,'/')) + 1;
      name = substr(filename,loca);
      name = substr(name, 1, length(name)-4);
      drop loca changed;
   RUN;

   /* Generate macro variable with name of each macro in dir */
   Data dir;
      IF _N_ = 1 THEN DO;
         i=0;
      END;
      SET dir end=eof;
      Call Symputx(catt("var",i), name);
      Call Symputx('l_name',name);
  
      IF eof THEN Call Symputx("l_count",i);
      i+1;
   RUN;

   /* Generate result data set */
   DATA listCalling;
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
   
      DATA dir;
         SET dir(WHERE=(filename not like "&l_path1" AND filename not like "&l_path2"));
      RUN;
   %END;
 
   /* Loop over macros to find references*/
   %LET l_loop = 1;
   %DO %WHILE (&l_loop);
      %LET l_loop = 0;

      Data dir;
         Modify dir(Where=(filename NE ''));
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
            /* Beginn of comment found */
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
                  IF find(line, trim(calledMacro), 'i') gt 0 THEN DO;
                     caller = resolve("&l_name");
                     keep line caller called;
                     output;
                  END;
               END;
            END;
         RUN;
         
         DATA _null_;
            SET helper nobs=cnt_obs;
            call symput('l_nobs', cnt_obs);
         RUN;
         
         %IF &l_nobs GT 0 %THEN %DO;
            /* Neglect multiple calls to the same macro */
            PROC sort DATA = helper nodupkey;
               BY called;
            RUN;

            /* Put caller into concatenated macro variable  */
            DATA _NULL_;
               SET helper end=eof;
               length cattVar $ 1000;
               retain cattVar;
               cattVar = called || cattVar;
               IF eof THEN DO;
                  call symput("l_cattVar", trim(cattVar));
                  call symput("l_cattVarLen", trim(left(_N_)));
               END;
            RUN;
            
            /* Append data from helper to calling macro-data set */     
            PROC append base=listCalling DATA=helper;
               where caller ne called;
            RUN;
         %END;
      %END; /* %IF &l_loop %THEN %DO */
   %END;/* Loop over macros to find references*/

   /* Use results from scan to build hierarchy*/
   PROC SQL noprint;
      create table stage1 as
      select distinct caller, called
      from listcalling as l1
      where called not in (select distinct caller from listcalling as l2)
      ;
      select count(caller) into: nobs
      from stage1
      ;
   QUIT;

   %LET n = 2;
   %LET l_loop = 1;

   /* Iterate over stageX data sets till no more observations are appended and all
     dependencies are found */
   %DO %while (&l_loop);
      %LET nobs_old = &nobs.;

      PROC SQL noprint;
         create table stage&n. as
         select l.caller, trim(s.caller)||','||trim(s.called) as called
         from listcalling as l
         join stage%eval(&n.-1) as s
         on l.called = s.caller
         union
         select s2.caller, s2.called
         from stage%eval(&n.-1) as s2
         order by caller
         ;
         select count(caller) into: nobs
         from stage&n.
         ;
      QUIT;
      %LET n = %eval(&n. + 1);
      %IF &nobs eq &nobs_old %THEN %LET l_loop=0;
   %END;

   /* Get dependency information for scenarios and all called macros */
   DATA dependency;
      SET stage%eval(&n.-1);
      keep caller calledByCaller;
      caller = catt(caller,".sas");
      cnt = count(called,',');
      DO i=1 TO cnt+1;
         calledByCaller = catt(scan(called,i,','),".sas");
         OUTPUT; 
      END;
   RUN;
   
   PROC SORT DATA=dependency NODUPKEY;
      BY caller calledByCaller;
   RUN;
   
   %IF &g_verbose =0 %THEN %DO;
      options &source &notes &mprint;
   %END;
%MEND _crossreference;
/** \endcond */