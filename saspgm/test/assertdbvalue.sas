/** \file
   \ingroup    SASUNIT_UTIL

   \brief      Hilfsmakro für die Tests von SASUNIT - prüfen von Werten in der Testdatenbank

   \version    \$Revision: 53 $
   \author     \$Author: mangold $
   \date       \$Date: 2009-07-16 14:45:22 +0200 (Do, 16 Jul 2009) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/saspgm/test/assertdbvalue.sas $

   \param   i_tab        tsu, scn, cas oder tst
   \param   i_col        Spaltenname ohne Präfix
   \param   i_val        Wert
   \param   i_desc       optional: Beschreibung des Tests
*/ /** \cond */

/* Änderungshistorie
   30.06.2008 AM  führende Blanks abschneiden beim Holen des Werts aus der Datenbank
*/ 

%macro assertDBValue(
    i_tab
   ,i_col
   ,i_val
   ,i_desc
);

%let i_val=%superq(i_val);

   proc sql noprint;
%let i_tab = %upcase(&i_tab);
%let i_col = %upcase(&i_col);

%local l_val;
      select &i_tab._&i_col into :l_val from target.&i_tab
         where  
%if &i_tab=SCN %then %do;
            scn_id = &scnid
%end;
%else %if &i_tab=CAS %then %do;
            cas_scnid = &scnid and
            cas_id = &casid
%end;
%else %if &i_tab=TST %then %do;
            tst_scnid = &scnid and
            tst_casid = &casid and
            tst_id = &tstid
%end;
      ;
quit;
%let l_val=%qtrim(%qleft(%superq(l_val)));

%if &i_desc= %then
   %let i_desc=&i_tab..&i_col = &i_val;

%assertEquals(i_expected=&i_val, i_actual=&l_val, i_desc=&i_desc)

%mend assertDBValue;
 
/** \endcond */
