/**
\file
\ingroup    SASUNIT_UTIL

\brief      prüfe, ob ein Szenario ausgeführt werden muss:

            Szenarien, für die eine der folgenden Bedingungen zutrifft, müssen ausgeführt werden:
            - das Szenario ist bisher nicht bekannt
            - das Szenario wurde seit dem letzten Lauf geändert 
            - das Szenario enthält einen Testfall, dessen Prüfling 
              (absoluter oder relativer Pfad) seit dem letzten Lauf geändert wurde
            - das Szenario enthält einen Testfall, dessen Prüfling nicht gefunden wird
              (Szenario muss ausgeführt werden, damit man hierauf aufmerksam wird)

\param      i_scnfile Name des Testszenarioprogramms (absoluter Pfad)
\param      i_changed Änderungszeitpunkt (Datetimewert)
\param      i_dir SAS-Datei, in der alle Programme stehen, die in allen Autocall-Pfaden 
                  gefunden wurden. Die Datei enthält folgende Variablen: 
                  - filename Absoluter Pfad zu der Datei 
                  - changed  Änderungsdatum
                  - auton    Autocall-Nummer 0..9
                  (erzeugt mit _sasunit_dir)
\param      r_scnid Name der Makrovariable, in der die Szenario-Id zurückgegeben wird, 
                    falls das Szenario bereits bekannt ist, andernfalls 0
\param      r_run Name der Makrovariable, in der 1 (ausführen) oder 0 (nicht ausführen) 
                  zurückgegeben wird
\return     &r_scnid und &r_run
*/ /** \cond */ 

/* Änderungshistorie
   15.12.2007 AM  Neuerstellung 
*/ 

%MACRO _sasunit_checkScenario(
   i_scnfile = 
  ,i_changed = 
  ,i_dir     = 
  ,r_scnid   = l_scnid
  ,r_run     = l_run
);

%local d_pgm;
%_sasunit_tempFileName(d_pgm)

/*-- Standardwert der Rückgabe setzen ----------------------------------------*/
%let &r_scnid=;
%let &r_run=0; 

/*-- absoluten Pfad standardisieren ------------------------------------------*/
%local l_scnfile;
%let l_scnfile = %_sasunit_stdPath (&g_root, &i_scnfile);

/*-- Ausführungszeitpunkt Testszenario ermitteln -----------------------------*/
%local ll_scnid l_lastrun;
%let l_lastrun=0;
%let ll_scnid=0;
proc sql noprint;
   select scn_id, compress(put(scn_start,best32.)) into :ll_scnid, :l_lastrun
   from target.scn
   where upcase(scn_path) = "%upcase(&l_scnfile)";
quit;

/*-- Ausführen, wenn Szenario nicht gefunden oder gefunden und geändert ------*/
%if &l_lastrun<&i_changed %then %do;
   %put _sasunit_checkScenario <1>;
   %let &r_scnid = &ll_scnid;
   %let &r_run = 1;
   %goto exit;
%end;

/*-- ermittle Prüflinge in Autocallpfaden und deren Änderungsdatum -----------*/
%local l_pgmcount;
%let l_pgmcount=0;
proc sql noprint;
   select count(*) into :l_pgmcount
   from target.cas
      left join &i_dir dir 
         on upcase(cas.cas_pgm) = upcase(scan(dir.filename,-1,'/'))
            and cas.cas_auton = dir.auton
   where cas.cas_scnid = &ll_scnid
      and (&l_lastrun<dir.changed or dir.changed=.)
      and cas.cas_auton ne .
   ;
quit;

/*-- Ausführen, wenn ein Programm neuer ist oder fehlt -----------------------*/
%if &l_pgmcount %then %do;
   %put _sasunit_checkScenario <2>;
   %let &r_scnid = &ll_scnid;
   %let &r_run = 1;
   %goto exit;
%end;

/*-- ermittle Prüflinge außerhalb Autocallpfaden -----------------------------*/
proc sql noprint;
   create table &d_pgm as
      select cas.cas_pgm
      from target.cas
      where cas.cas_scnid = &ll_scnid
         and cas.cas_auton=.
   ;
quit;

/*-- nicht ausführen, wenn kein Programm außerhalb Autocallpfaden gefunden ---*/
%if %_sasunit_nobs(&d_pgm) = 0 %then %do;
   %put _sasunit_checkScenario <3>;
   %let &r_scnid = &ll_scnid;
   %let &r_run = 0;
   %goto exit;
%end;

/*-- ermittle Änderungsdatum für diese Programme -----------------------------*/
%local i;
%do i=1 %to %_sasunit_nobs(&d_pgm);
   %local l_pgm&i;
%end;
data _null_;
   set &d_pgm;
   call symput ('l_pgm' !! compress(put(_n_,8.)), trim(cas_pgm));
   call symput ('l_pgmcount', compress(put(_n_,8.)));
run;

%do i=1 %to &l_pgmcount;
   %let l_pgm&i = %_sasunit_absPath(&g_root,&&l_pgm&i);
   %_sasunit_dir(i_path=&&l_pgm&i, o_out=&d_pgm)
   
   %local l_pgmchanged;
   %let l_pgmchanged=0;
   proc sql noprint;
      select compress(put(changed,best32.)) into :l_pgmchanged
         from &d_pgm
      ;
   quit;

   /*-- Szenario ausführen, wenn Prüfling neuer oder nicht gefunden ----------*/
   %if &l_lastrun < &l_pgmchanged or &l_pgmchanged=0 %then %do;
      %put _sasunit_checkScenario <4>;
      %let &r_scnid = &ll_scnid;
      %let &r_run = 1;
      %goto exit;
   %end;

%end;

/*-- Szenario nicht ausführen ------------------------------------------------*/
%put _sasunit_checkScenario <5>;
%let &r_scnid = &ll_scnid;
%let &r_run = 0;

%exit:
/*-- aufräumen ---------------------------------------------------------------*/
proc datasets nolist nowarn;
   delete %scan(&d_pgm,2,.);
quit;

%MEND _sasunit_checkScenario;
/** \endcond */
