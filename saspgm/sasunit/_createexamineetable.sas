/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Creates table target.exa with all possible examinees.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \todo _new_dir
   
*/ /** \cond */ 

%MACRO _createExamineeTable;

   %GLOBAL
      d_examinee
      d_dir
   ;

   %_tempFileName(d_examinee);
   %_tempFileName(d_dir);

   /*-- find out all possible units under test ----------------------------------*/
   %LET l_auto=&g_sasautos.;
   %LET l_autonr=0;
   %DO %WHILE("&l_auto" ne "");  
      %LET l_auto=%quote(&l_auto/);
      %_dir(i_path=&l_auto.*.sas, o_out=&d_dir);
      data &d_examinee.;
         set %IF &l_autonr>0 %THEN &d_examinee.; &d_dir.(in=indir);
         if indir then DO;
            auton=&l_autonr.+2;
            source=symgetc ("l_auto");
         end;
      run; 
      %LET l_autonr = %eval(&l_autonr+1);
      %LET l_auto=;
      %IF %symexist(g_sasautos&l_autonr) %THEN %LET l_auto=&&g_sasautos&l_autonr;
   %END;
   %IF (&g_crossrefsasunit.) %THEN %DO;
      %LET l_auto=&g_sasunit;
      %LET l_auto=%quote(&l_auto/);
      %_dir(i_path=&l_auto.*.sas, o_out=&d_dir);
      data &d_examinee.;
         set &d_examinee &d_dir(in=indir);
         if indir then DO;
            auton=0;
            source=symgetc ("l_auto");
         end;
      run; 
      %LET l_auto=&g_sasunit_os;
      %LET l_auto=%quote(&l_auto/);
      %_dir(i_path=&l_auto.*.sas, o_out=&d_dir);
      data &d_examinee.;
         set &d_examinee. &d_dir(in=indir);
         if indir then DO;
            auton=1;
            source=symgetc ("l_auto");
         end;
      run; 
   %END;

   proc sql noprint;
      create view work._examinee_v as
         select auton as exa_auton
               ,membername as exa_pgm length=1000
               ,changed format=datetime21.2
               ,filename as exa_filename length=1000
               ,source as exa_path length=1000
         from &d_examinee.
         order by auton, exa_pgm;
   quit;

   data work._examinee;
      set work._examinee_v;
      exa_path = resolve('%_stdPath(&g_root.,' || exa_filename || ')');
   run;     

   %let l_max_exaid=0;
   proc sql noprint;
      select max (exa_id) into :l_max_exaid from target.exa;
   quit;

   proc sort data=target.exa;
      by exa_auton exa_pgm;
   run;

   data &d_examinee.;
      merge work._examinee (in=inWork) target.exa (in=inTarget);
      by exa_auton exa_pgm;
      retain max_exaid &l_max_exaid.;
      if (inWORK and not inTarget) then do;
         max_exaid=sum (max_exaid,1);
         exa_id=max_exaid;
      end;
      exa_changed = coalesce (changed, exa_changed);
      drop max_exaid changed;
   run;

   data target.exa;
      set target.exa;
      stop;
   run;

   proc append base=target.exa data=&d_examinee.;
   run; 

   PROC DATASETS NOLIST NOWARN LIB=work memtype=(DATA VIEW);
      DELETE _examinee_v;
      DELETE _examinee;
   QUIT;

%MEND _createExamineeTable;
/** \endcond */
