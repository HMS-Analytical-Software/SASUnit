/**
   \file
   \ingroup    SASUNIT 

   \brief      Documentation of SASUnit, the unit testing framework for SAS(TM)-programs on Microsoft Windows (TM)

               Version 0.910 - beta for 1.0

               Copyright:\n
               Copyright (C) 2010 HMS Analytical Software GmbH, Heidelberg, Deutschland (http://www.analytical-software.de).
               You can use, copy, redistribute and/or modify this software under the terms of the GNU General Public License
               as published by the Free Software Foundation. This program is distributed WITHOUT ANY WARRANTY; without even 
               the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
               See the GNU General Public License for more details (http://www.gnu.org/licenses/). \n
               SASUnit contains parts of Doxygen, see http://www.doxygen.org

               System requirements:\n
               SASUnit Version 0.910 runs on SAS(R) 9.1.3 Service Pack 4 and SAS 9.2 for Microsoft Windows(R) 
               and on SAS 9.2 for Linux.\n
               SAS is a product and registered trademark of SAS Institute, Cary, NC (http://www.sas.com).

               Installation und windows: \n
               SASUnit is obtainable at http://sourceforge.net/projects/sasunit/
               Unzip the contents of the ZIP-File to c:\\projects\\sasunit or to a directory of your choice. 
               If you change the directory, you have to change two paths in example\\saspgm\\run_all.sas.
               Check the sasunit.xxx.cmd-files in the examples\\bin directory for the correct path to the SAS executable.

               Getting started:\n
               - Have a look at the documentation of SASUnit and the examples at example\\doc\\doxygen\\html\\index.html. 
               - Have a look at the SASUnit example output at example\\doc\\sasunit\\rep\\index.html.
               - Write your own examples and test scenarios in example\\saspgm. Test scenarios have the postfix
                 _test.sas. If applicable, save your test data in example\\dat.
               - Start SASUnit using example\\bin\\sasunit.xxx.cmd (xxx is your SAS version). 
                 SASUnit is executed in a batch SAS session that invokes each test scenario in an own SAS session. 

               Structure of a test suite (see run_all.sas):

               - \%initSASUnit (initSASUnit.sas) opens a test repository or, in case it does not yet exist, creates one.
                 Steps of \%initSASUnit:
                 - Check parameters
                 - Check whether in the path that is defined in io_target a test repository exists
                   or whether it was requested by i_overwrite to recreate the test repository. 
                   In case a test repository already exists:
                   - test repository is updated with parameters
                   Else:
                   - test repository is newly created and updated with parameters
                 - Libref target for the test repository is kept assigned

               - \%runSASUnit (runSASUnit.sas) executes one or more test scenarios.
                 The parameter i_source determines, which SAS programm is executed as a test scenario. 
                 It is possible to use DOS wildcards (e.g. *_test.sas) to execute all test scenarios
                 that match the pattern.
                 Procedure of \%runSASUnit:
                 - Check whether test repository was already initialized with \%initSASUnit, if not: End.
                 - Determination of the test scenarios to be invoked.
                 - For every test scenario:
                   - Check whether it already exists in the test repository.
                   - if yes: Check whether the test scenario was changed since last invocation.
                   - if no:  Creation of the test scenario in the test repository.
                   - In case the test scenario is new or changed:
                     - The test scenario is executed in an own SAS session which is initialized
                       by _sasunit_scenario.sas .
                       All test results are gathered in the test repository. 

               - \%reportSASUnit (reportSASUnit.sas)
                 - Check whether test repository was already initialized with \%initSASUnit, if not: End.
                 - Determination of the necessary informations out of the test repository
                 - Creation of the test report in HTML or RTF format

               - Every test scenario is a SAS program that comprises one or more
                 test cases and that is executed in an own SAS session.
                 Procedure:
                 - if applicable: prepare test data for the following test cases
                 - test case 1
                 - test case 2
                 - ...
                 - test case n
                 The test scenarios are executed by \%runSASUnit (see above).

               - Every test case comprises the following steps: 
                 - \%beginTestcase (beginTestcase.sas)
                 - test setup: if applicable, prepare test data
                 - Invocation of the program under test
                 - \%endTestcall (endTestcall.sas)
                 - Assertions, i.e. comparison of expected and actual results:
                   - \%assertEquals - Check macro variables (assertEquals.sas)
                   - \%assertColumns - Check table columns (assertColumns.sas)
                   - \%assertLog - Check the number of error and warning messages in the SAS Log (assertLog.sas)
                   - \%assertLogMsg - Check whether a certain message appears in the log (assertLogMsg.sas)
                   - \%assertReport - Check whether a report file exists and was created during the current SAS session.
                                      Optionally it is possible to write an instruction into the test protocol indicating 
                                      the need to perform a manual check of the report (assertReport.sas)
                   - \%assertLibrary - Check whether all files are identical in different libraries (assertLibrary.sas)
                 - \%endTestcase (endTestcase.sas)
 
               For creation of test scnarios, it is possible to use the following global macro variables, filenames and libnames.
               Their values are initialized by invocation of initSASUnit:
               - macro variables
                 - g_project - see parameter i_project
                 - g_target - see parameter io_target 
                 - g_root - see parameter i_root
                 - g_sasunit - see parameter i_sasunit - absolute path
                 - g_sasautos - see parameter i_sasautos - absolute path
                 - g_sasautos1..9 - see parameter i_sasautos1..9 - absolute path
                 - g_testdata - see parameter i_testdata - absolute path
                 - g_refdata - see parameter i_refdata - absolute path
                 - g_doc - see parameter i_doc - absolute path
                 - g_error - symbol for error - ERROR or FEHLER
                 - g_warning - symbol for warning - WARNING or WARNUNG
                 - g_scnid - Id number of test scenario
                 - g_work - path of work directory
                 - g_testout - see parameter io_target, subdirectory tst
                 - g_version - current version of SASUnit
                 - g_revision - current Subversion revision number
               - Libnames
                  - target - see parameter io_target
                  - testout - see parameter io_target, subdirectory tst
                  - testdata - see parameter i_testdata
                  - refdata - see parameter i_refdata
               - Filenames
                  - target - see parameter io_target
                  - testout - see parameter io_target, subdirectory tst
                  - testdata - see parameter i_testdata
                  - refdata - see parameter i_refdata
                  - doc - see parameter i_doc
               
               Structure of the test repository (directory io_target)
                  - test repository based on the following SAS files (Libref target)
                     - tsu .. one observation with the preferences for the whole test suite
                     - scn .. one observation per test scenario
                     - cas .. one observation per test case
                     - tst .. one observation per assertion
                  - subdirectories:
                     - log .. SAS logs and HTML files created out of the HTML files
                       <scenario-id>.log .. SAS log of every test scenario
                       <scenario-id>_<testcase-id>.log .. SAS log of every test case
                     - tst .. result files generated by checks of assertions (e.g. proc compare report)
                     - rep .. files generated by the report generator
*/

/*DE
   \file
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
