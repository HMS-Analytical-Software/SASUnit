/** \file
   \ingroup    SASUNIT 

   \brief      Dokumentation von SASUnit, dem Unittesting Framework für SAS(TM)-Programme unter Microsoft Windows (TM)

               Version 0.9

               Copyright:\n
               Copyright 2008 durch HMS Analytical Software GmbH, Heidelberg, Deutschland (http://www.analytical-software.de).
               Hiermit gewähren wir das Recht, diese Software und ihre Dokumentation 
               unter der GNU General Public License zu verwenden, zu kopieren,
               zu verändern und zu verteilen. Wir machen keinerlei Zusicherungen über die Funktionsfähigkeit dieser
               Software für irgendeinen Zweck. Näheres siehe http://www.gnu.de/gpl-ger.html \n 
               SASUnit enthält Teile von Doxygen, siehe http://www.doxygen.org

               Systemvoraussetzungen:\n
               SASUnit Version 0.9 ist lauffähig unter SAS(R) 9.1.3 Service Pack 4 für Microsoft Windows(R).\n
               SAS ist ein Produkt von SAS Institute, Cary, NC (http://www.sas.com).

               Installation: \n
               SASUnit ist erhältlich unter http://www.redscope.org/sasunit
               Entpacken Sie den Inhalt des ZIP-Files unter c:\\projekte\\sasunit oder nehmen Sie folgende Änderungen vor, 
               um die Beispiele lauffähig zu machen:
               - Verknüpfung sasunit\\example\\bin\\SASUnit anpassen
               - Pfade in sasunit\\example\\saspgm\\run_all anpassen
               - Falls doxygen verwendet werden soll (siehe http://www.redscope.org/artikel/doxygen)
                 - Verknüpfungen "Doxygen ..." unter sasunit\\example\\bin\\ anpassen
                 - Pfade ändern unter "sasunit\example\bin\Doxygen GUI starten"

               Inbetriebnahme:\n
               - Rufen Sie die Dokumentation von SASUnit und der Beispiele auf unter sasunit\example\doc\doxygen. 
               - Rufen Sie das Testprotokoll der Beispielprogramme auf unter sasunit\\example\\doc\\sasunit.
               - Schreiben Sie eigene Beispiele und Testszenarien in sasunit\\example\\saspgm. Testszenarien haben die 
               Endung _test.sas. Ihre Testdaten legen Sie ggfs. nach sasunit\\example\\dat.
               - Starten Sie SASUnit mit sasunit\\example\\bin\\SASUnit. 
                 SASUnit wird in einer Batch-SAS-Sitzung ausgeführt, die alle Testszenarien wiederum in je einer eigenen SAS-Sitzung aufruft. 

               Struktur einer Testsuite (siehe run_all.sas):

               - \%initSASUnit (initSASUnit.sas) öffnet eine Testdatenbank oder legt sie an, falls sie noch nicht existiert. 
                 Ablauf von \%initSASUnit:
                 - Parameter prüfen
                 - prüfen, ob in dem Pfad, der in io_target angegeben ist, noch keine Testdatenbank
                   existiert oder ob mit i_overwrite das Neuanlegen der Testdatenbank angefordert wurde. 
                   Wenn nein:
                   - Testdatenbank mit Parametern aktualisieren
                   Sonst:
                   - Testdatenbank neu anlegen und mit Parametern belegen
                 - Libref target für Testdatenbank bleibt zugewiesen

               - \%runSASUnit (runSASUnit.sas) führt ein Testszenario oder mehrere Testszenarien aus.
                 Im Parameter i_source wird angegeben, welches SAS-Programm als Testszenario auszuführen ist. 
                 Es können auch DOS-Wildcards (z.B. *_test.sas) angegeben werden, dann werden alle 
                 Testszenarien ausgeführt, die dem Suchmuster entsprechen. 
                 Ablauf von \%runSASUnit:
                 - prüfen, ob Testdatenbank mit \%initSASUnit initialisiert wurde, wenn nein: Ende
                 - ermitteln der auszuführenden Testszenarien
                 - für jedes Testszenario:
                   - prüfen, ob es schon in der Testdatenbank existiert
                   - wenn ja: prüfen, ob das Testszenario seit dem letzten Aufruf geändert wurde
                   - wenn nein: Anlegen des Testszenarios in der Testdatenbank
                   - wenn Testszenario neu oder geändert:
                     - Testszenario in einer eigenen SAS-Sitzung ausführen,
                       die über _sasunit_scenario.sas initialisiert wird.
                       Alle Testergebnisse werden in der Testdatenbank gesammelt 

               - \%reportSASUnit (reportSASUnit.sas)
                 - prüfen, ob Testdatenbank mit \%initSASUnit initialisiert wurde, wenn nein: Ende
                 - ermitteln der benötigten Informationen aus der Testdatenbank
                 - Bericht erstellen im HTML- oder RTF-Format

               - Jedes Testszenario ist ein eigenes SAS-Programm, das aus einem oder 
                 mehreren Testfällen besteht und das in einer eigenen SAS-Sitzung ausgeführt wird.
                 Ablauf:
                 - ggfs. Testdaten für die folgenden Testfälle vorbereiten
                 - Testfall 1
                 - Testfall 2
                 - ...
                 - Testfall n
                 Die Testszenarien werden mit \%runSASUnit (s.o.) ausgeführt.

               - Jeder Testfall ist wie folgt aufgebaut: 
                 - \%beginTestcase (beginTestcase.sas)
                 - Testsetup: ggfs. Daten vorbereiten
                 - Prüfling aufrufen
                 - \%endTestcall (endTestcall.sas)
                 - Prüfungen durchführen, also erwartete und tatsächliche Ergebnisse vergleichen:
                   - \%assertEquals - Makrovariable prüfen (assertEquals.sas)
                   - \%assertColumns - Tabellenspalten prüfen (assertColumns.sas)
                   - \%assertLog - Anzahl Fehlermeldungen und Warnungen im Log prüfen (assertLog.sas)
                   - \%assertLogMsg - prüfen, ob eine bestimmte Meldung im Log steht (assertLogMsg.sas)
                   - \%assertReport - prüfen, ob eine erzeugte Reportdatei existiert 
                     und in der laufenden SAS-Sitzung erzeugt wurde und (optional) eine Anweisung zum    
                     "manuellen" Prüfen in das Testprotokoll schreiben (assertReport.sas)
                   - \%assertLibrary - prüfen, ob Datasets in einer Library übereinstimmen (assertLibrary.sas)
                 - \%endTestcase (endTestcase.sas)
 
               Es können in den Testszenarien folgende globalen Makrovariablen, Filenames und Libnames verwendet werden, 
               deren Wert durch den Aufruf von initSASUnit bestimmt wird:
               - Makrovariablen
                 - g_project - siehe Parameter i_project
                 - g_target - siehe Parameter io_target 
                 - g_root - siehe Parameter i_root
                 - g_sasunit - siehe Parameter i_sasunit - absoluter Pfad
                 - g_sasautos - siehe Parameter i_sasautos - absoluter Pfad
                 - g_sasautos1..9 - siehe Parameter i_sasautos1..9 - absoluter Pfad
                 - g_testdata - siehe Parameter i_testdata - absoluter Pfad
                 - g_refdata - siehe Parameter i_refdata - absoluter Pfad
                 - g_doc - siehe Parameter i_doc - absoluter Pfad
                 - g_error - Symbol für Fehler - ERROR oder FEHLER
                 - g_warning - Symbol für Warnungen - WARNING oder WARNUNG
                 - g_scnid - Idnummer des Testszenarios
                 - g_work - Pfad des Workverzeichnisses
                 - g_testout - siehe Parameter io_target, Unterverzeichnis tst
                 - g_version - aktuelle Version von SASUnit
                 - g_revision - aktuelle Subversion-Revisionsnummer
               - Libnames
                  - target - siehe Parameter io_target
                  - testout - siehe Parameter io_target, Unterverzeichnis tst
                  - testdata - siehe Parameter i_testdata
                  - refdata - siehe Parameter i_refdata
               - Filenames
                  - target - siehe Parameter io_target
                  - testout - siehe Parameter io_target, Unterverzeichnis tst
                  - testdata - siehe Parameter i_testdata
                  - refdata - siehe Parameter i_refdata
                  - doc - siehe Parameter i_doc
               
               Aufbau der Testdatenbank (Verzeichnis io_target)
                  - Testdatenbank in SAS-Dateien (Libref target)
                     - tsu .. ein Datensatz mit den Einstellungen für die komplette Testsuite
                     - scn .. ein Datensatz pro Testszenario
                     - cas .. ein Datensatz pro Testfall
                     - tst .. ein Datensatz pro Test (assert)
                  - Unterordner:
                     - log .. SAS-Logs und daraus erzeugte HTML-Dateien
                       <scenario-id>.log .. SAS-Log jedes Testszenarios
                       <scenario-id>_<testcase-id>.log .. SAS-Log jedes Testcase
                     - tst .. Ergebnisdateien von Tests (z.B. Compare-Report)
                     - rep .. vom Reportgenerator erzeugte Dateien
*/ 
