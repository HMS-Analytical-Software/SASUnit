/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Ausführen aller Beispiel-Testszenarien

            Initialisieren von SASUnit (Testdatenbank öffnen bzw. bei Bedarf neu erzeugen) mit \%initSASUnit
            - Projektnamen setzen
            - variablen Einstiegspfad setzen
            - relative Pfade für SASUnit-Makropaket, Testdatenbank, 
              Prüflinge, Test- und Referenzdaten setzen

            Mit \%runSASUnit alle Testszenarien (Endung _test.sas) im Verzeichnis example\saspgm
            ausführen, bei denen das Testszenario oder der Prüfling 
            seit dem letzten Lauf geändert wurden.

            Mit \%reportSASUnit alle Reportseiten neu erstellen, die aufgrund der ausgeführten 
            Testszenarien neu erstellt werden müssen
            
\version    \$Revision: 50 $
\author     \$Author: mangold $
\date       \$Date: 2009-07-16 10:29:18 +0200 (Do, 16 Jul 2009) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/example/saspgm/run_all.sas $
*/ /** \cond */ 

/* Änderungshistorie
   05.09.2008 NA  Anpassungen Linux
   06.02.2008 AM  Neuerstellung 
*/ 

OPTIONS 
   MPRINT MAUTOSOURCE NOMLOGIC NOSYMBOLGEN
   SASAUTOS=(SASAUTOS "c:/projekte/sasunit.903/saspgm/sasunit") /* SASUnit-Makrobibliothek */
;

/* Testdatenbank öffnen bzw. beim ersten Mal neu erstellen */
%initSASUnit(
   i_root       = c:/projekte/sasunit.903 /* Einstiegspfad, weitere Pfade relativ dazu */
  ,io_target    = example/doc/sasunit /* Ausgabe von SASUnit: Logs, Ergebnisse, Report */
  ,i_overwrite  = 0                   /* auf 1 setzen, um die Ausgabe komplett zu erstellen, 
                                         andernfalls werden nur geänderte Szenarien ausgeführt */
  ,i_project    = SASUnit Examples    /* Projektname, für Report */
  ,i_sasunit    = saspgm/sasunit      /* SASUnit-Makrobibliothek */
  ,i_sasautos   = example/saspgm      /* Suchpfad für Prüflinge - Makros */
  ,i_testdata   = example/dat         /* Testdaten, libref testdata */
  ,i_refdata    = example/dat         /* Referenzdaten, libref refdata */
  ,i_doc        = example/dat         /* Spezifikationsdokumente */
)

/* angegebene Testszenarien ausführen, kann auch mehrfach oder für einzelne Szenarien
   aufgerufen werden */
%runSASUnit(i_source = example/saspgm/%str(*)_test.sas)

/* Report erstellen */
%reportSASUnit()

/** \endcond */
