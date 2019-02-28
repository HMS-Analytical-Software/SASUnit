/**
   \file
   \ingroup    SASUNIT_UTIL
   
   \brief      The macro allows to gather cross reference information between different macros. A calling
               hierarchy is established for the directories found in the test database in columns 
               tsu_sasautos1 to tsu_sasautos9. If i_includeSASUnit is set to 1 the directories in tsu_sasunit, 
               tsu_sasunit_os and tsu_sasautos are included as well in the scan.
               Libref target has to be set.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      i_includeSASUnit  Include the SASUnit core macros in scan or not, default set to 0
   \param      i_examinee        Data set containing content of autocall libraries 
   \param      o_listcalling     Output data set with columns caller and called representing the calling hierarchy
   \param      o_dependency      Output data set holding results of this macro needed in macro _checkScenario
   \param      o_macroList       Output data set with list of all macros, needed for visualization of calling hierarchy

   \todo Since options mprintnest is already available with SAS9.2 use this option for cross reference from various logfiles.
         We could use this for the d3d graphics to speed up reporting a bit.
         For executing all calling macros of an examinee we still need sourcecode scanning.
         Or we need to store this call reference from last run.

*/ /** \cond */ 

%MACRO _crossreference(i_includeSASUnit  =0
                      ,i_examinee        =
                      ,o_listcalling     =
                      ,o_dependency      =
                      ,o_macroList       =
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
   
   %IF &g_verbose. =0 %THEN %DO;
      %let l_source =%sysfunc(getoption(source));
      %let l_notes  =%sysfunc(getoption(notes));
      %let l_mprint =%sysfunc(getoption(mprint));
      
      options nomprint nonotes nosource;
   %END;

   /* Decide which macros to scan: 1 = all macros, 0 = skip SASUnit macros */
   %IF &i_includeSASUnit. ne 0 %THEN %LET l_includeSASUnit=1;
   %ELSE %LET l_includeSASUnit=0;
   
   /* Keep all .sas files and get macro names*/
   DATA &o_macroList.;
      SET &i_examinee.;
      IF index(exa_filename,'.sas') = 0 THEN delete;
      loca = length(exa_filename) - length(scan(exa_filename,-1,'/')) + 1;
      name = substr(exa_filename,loca);
      name = substr(name, 1, length(name)-4);
      drop loca;
   RUN;
   
   /* l_includeSASUnit = 1: include sasunit macros in scan   */
   /* Paths for SASUnit macros will be omitted if l_includeSASUnit = 0 */
   %IF &l_includeSASUnit. = 0 %THEN %DO;
      PROC SQL noprint;
         select tsu_sasunit_os into: l_sasunit_os
         from target.tsu
      ;
      QUIT;
      
      %LET l_path1 = %_abspath(&g_root,&g_sasunit)/%;
      %LET l_path2 = %_abspath(&g_root,&l_sasunit_os)/%;
      *** Omit SASUnit macropaths ***;  
      DATA &o_macroList.;
         SET &o_macroList.(WHERE=(exa_filename not like "&l_path1" AND exa_filename not like "&l_path2"));
      RUN;
   %END;
 
   PROC SORT DATA=&o_macroList. NODUPKEY;
      BY exa_filename;
   RUN;

   /* Generate macro variable with name of each macro in &o_macroList */
   Data &o_macroList.;
      SET &o_macroList. end=eof;
      Call Symputx(catt("var",_N_), name,'L');
      Call Symputx(catt('l_filename',_N_),exa_filename,'L');
  
      IF eof THEN Call Symputx("l_count",_N_);
   RUN;

   /* Generate result data set */
   DATA &o_listcalling.;
      length caller called $ 80
             line $ 256;
      STOP;
   RUN;

   /* Loop over macros to find references*/
   %DO l_macro = 1 %to &l_count.;
      /* Find all macro calls in a macro */
      %IF %SYSFUNC(FILEEXIST(&&l_filename&l_macro.)) %THEN %DO;
         DATA work.helper;
            IF _N_ = 1 THEN DO;
               retain pattern1 ptrn_Com_1_o ptrn_Com_1_c;
               retain l_DoxyHeader 0 comment 0;
               length line $ 256
                      caller called $ 80;
               pattern1 = prxparse('/%/');
               ptrn_Com_1_o = prxparse('/\/\*/');
               ptrn_Com_1_c = prxparse('/\*\//');
            END;

            INFILE "&&l_filename&l_macro." truncover;
            INPUT;
            line = lowcase (trim(left(_INFILE_)));
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
               DO x=1 to &l_count.;
                  called      = resolve(catt('&var',x));
                  calledMacro = catt('%',called);
                  findpos = find(line, trim(calledMacro), 'i');
                  /* candidate found */
                  IF findpos gt 0 THEN DO;
                     len = length(trim(calledMacro));
                     /* make sure found string is whole macro name and not only a substring */
                     substring = substr(line, findpos+len,1);
                     IF substring in ('(',' ',';')  THEN DO;
                        caller = "&&var&l_macro.";
                        KEEP line caller called;
                        OUTPUT;
                     END;
                  END;
               END;
            END;
         RUN;
         
         DATA _NULL_;
            SET work.helper nobs=cnt_obs;
            call symput('l_nobs', put(cnt_obs, 4.));
         RUN;

         %IF &l_nobs GT 0 %THEN %DO;
            /* Neglect multiple calls to the same macro */
            PROC sort DATA = work.helper nodupkey;
               BY called;
            RUN;
            /* Append data from helper to calling macro-data set */     
            PROC append base=&o_listcalling DATA=work.helper;
               where caller ne called;
            RUN;
         %END;
      %END;
   %END;/* Loop over macros to find references*/

   /* Use results from scan to build hierarchy*/
   PROC SQL noprint;
      create table stage1 as
      select distinct caller, called
      from &o_listcalling as l1
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
         join &o_listcalling. as l
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

   /* Get dependency information for scenarios and all called macros */
   DATA &o_dependency;
      SET stage&n.;
      keep caller calledByCaller;
      caller = catt(caller,".sas");
      cnt = count(called,',');
      DO i=1 TO cnt+1;
         calledByCaller = catt(scan(called,i,','),".sas");
         OUTPUT; 
      END;
   RUN;
   
   PROC SORT DATA=&o_dependency NODUPKEY;
      BY caller calledByCaller;
   RUN;
   
   %IF &g_verbose =0 %THEN %DO;
      options &l_source &l_notes &l_mprint;
   %END;

   proc datasets lib=work nolist;
      delete helper stage:;
   run;quit;
%MEND _crossreference;
/** \endcond */
