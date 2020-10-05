/**
   \file
   \ingroup    SASUNIT_REPORT 

   \brief      Creates tageset used with ODS for generating JUnit-XML output.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
*/ /** \cond */ 
%MACRO _reportCreateTagset;

      PROC TEMPLATE;
         define tagset tagsets.JUnit_XML;
            indent=3;
            
            define event doc;
               start:
                  put '<?xml version="1.0" encoding="ISO-8859-1" ?>' NL;
                  put '<testsuites>' NL;
               finish:
                  trigger handleOpenTestsuite;
                  put '</testsuites>' NL;
            end;

            define event row;
               finish: /* Output the current row-data gathered within the event 'data' and stored within the associative array 'myRow' */
                  trigger printScenario / if cmp($myRow["isScenario"], "1");
                  trigger printTestcase / if cmp($myRow["isScenario"], "0");
                  UNSET $myRow;
                  UNSET $failuresUnformatted;
            end;

            define event data;
               /* Store the data of each cell of the current row in the associative array 'myRow' for outputing it in the row.finish-event */
               SET $myRow[NAME] VALUE;
               SET $failuresUnformatted UNFORMATTEDVALUE / if cmp(NAME,"failures");
            end;

            define event handleOpenTestsuite;
               DO / if cmp($hasOpenTestsuite, "1");
                  put '</testsuite>' NL;
                  XDENT;
                  set $hasOpenTestsuite "0";
               DONE;
            end;

            define event printScenario;
               trigger handleOpenTestsuite;
               NDENT;
               put '<testsuite' NL;
               put '  tests     ="' compress($myRow['tests'])    '"' NL;
               put '  failures  ="' compress($myRow['failures']) '"' NL;
               put '  id        ="'          $myRow['id']        '"' NL;
               put '  name      ="'          $myRow['name']      '"' NL;
               put '  package   ="'          $myRow['classname'] '"' NL;
               put '  time      ="' compress($myRow['time'])     '"' NL;
               put '  timestamp ="'          $myRow['timestamp'] '"' NL;
               put '>' NL;
               SET $hasOpenTestsuite "1";
            end;

            define event printTestcase;
               NDENT;
               put '<testcase' NL;
               put '  classname ="'          $myRow['classname'] '"' NL;
               put '  name      ="'          $myRow['name']      '"' NL;
               put '  time      ="' compress($myRow['time'])     '"' NL;
               put '  timestamp ="'          $myRow['timestamp'] '"' NL;
               put '  id        ="'          $myRow['id']        '"' NL;
               DO / if ^cmp($failuresUnformatted, "0");
                  put '>' NL;
                  trigger printFailure;
                  put '</testcase>' NL;
               ELSE;
                  put ' />' NL;
               DONE;
               XDENT;
            end;

            define event printFailure;
               NDENT;
               put '<failure' NL;
               put '  message ="' $myRow['message'] '"' NL;
               put '  type   = "' $myRow['type']    '"' NL;
               PUT '>' $myRow['message'] '</failure>' NL;
               XDENT;
            end;
         end;
      RUN; /* PROC TEMPLATE */

%MEND _reportCreateTagset;
/** \endcond */