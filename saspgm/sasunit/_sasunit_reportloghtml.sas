/** \file
   \ingroup    SASUNIT_REPORT

   \brief      log-File in HTML umwandeln

               Fehler- und Warnmeldungen werden markiert und verlinkt

   \param i_log     Logdatei mit kpl. Pfad
   \param i_title   String für Titel
   \param o_html    html-Datei Ausgabe kpl. Pfad
   \param r_rc      Name der Makrovariable mit dem Returncode
                    0 ...  kein Fehler, keine Warnung aufgetreten
                    1 ...  Warnungen aufgetreten
                    2 ...  Fehler (ggfs. auch Warnungen) aufgetreten
                    3 ...  Fehler im Ablauf dieses Makros

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

/* change log
   19.08.2008 AM  national language support
   06.07.2008 AM  Einfärbung nur, wenn hinter Error oder Warning ein Doppelpunkt steht
   10.08.2007 PW  Erste Version 
*/ 

%MACRO _sasunit_reportLogHTML(
    i_path    =
   ,i_log     =
   ,i_title   = SAS-Log
   ,o_html    =
   ,r_rc      = logrc
);
%LOCAL l_macname; %LET l_macname=&sysmacroname;

%LOCAL l_log l_html;
%LET l_log  = &i_log;
%LET l_html = &o_html;

%LET &r_rc=3;

/*erster Log-Durchlauf zur Bestimmung von Fehler- und Warnungsanzahl*/  
%LOCAL 
   l_error_count 
   l_warning_count 
   l_curError 
   l_curWarning 
   l_sym1 
   l_sym2
;

/* TODO consolidate logscan logic into datastep functions and use them throughout the project
*/
DATA _null_;
   INFILE "&l_log" END=eof TRUNCOVER;
   INPUT logline $char255.;
%let l_sym1=%substr(&g_error,1,1);/* avoid occurences of error-symbol followed by colon */
%let l_sym2=%substr(&g_error,2);
   IF index (logline, "&l_sym1&l_sym2:") = 1 THEN error_count+1;
%let l_sym1=%substr(&g_warning,1,1);
%let l_sym2=%substr(&g_warning,2);
   IF index (logline, "&l_sym1&l_sym2:") = 1 THEN warning_count+1;
   IF eof THEN DO;
      CALL symput ("l_error_count"  , compress(put(error_count,8.)));
      CALL symput ("l_warning_count", compress(put(warning_count,8.)));
   END;
RUN;


%IF %_sasunit_handleError(&l_macname, LogNotFound, 
   &syserr NE 0, 
   Fehler beim Zugriff auf den Log) 
   %THEN %GOTO errexit;

DATA _null_;
   INFILE "&l_log" END=eof TRUNCOVER;
   FILE "&l_html";
   INPUT logline $char255.;
   IF _n_=1 THEN DO;
      /*HTML-Header*/
      PUT '<html>';
      PUT '<head>';
      PUT '<meta http-equiv="Content-Language" content="de">';
      PUT '<meta name="GENERATOR" content="SAS &sysver">';
      PUT '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">';
      PUT "<title>&i_title</title>";
      PUT '</head>';
      /*HTML-Body*/
      PUT '<body>';
      /*Ausgabe einer Seiten-Kopfzeile mit verlinkter Übersicht zu Fehler- und Warnmeldungen*/
      PUT '<p style="background-color:#EAEAEA; font-family:Fixedsys,Courier,monospace">';
      PUT "&g_nls_reportLog_001: &l_error_count. ";
      %DO l_curError = 1 %TO &l_error_count.;
         IF &l_curError=1 THEN PUT '==>';
         PUT '<a href="#error' "%sysfunc(putn(&l_curError,z3.))" '">' "&l_curError." '</a>';
      %END;
      PUT '<br>';
      PUT "&g_nls_reportLog_002: &l_warning_count. ";
      %DO l_curWarning = 1 %TO &l_warning_count.;
         IF &l_curWarning=1 THEN PUT '==>';
         PUT '<a href="#warning' "%sysfunc(putn(&l_curWarning,z3.))" '">' "&l_curWarning." '</a>';
      %END;
      PUT '<br>';
      PUT '</p>';
      PUT '<pre>';
   END;
   /*Ausgabe der Log-Zeilen. Fehler- und Warnmeldungen werden farbig markiert und verlinkt*/   
%let l_sym1=%substr(&g_error,1,1);
%let l_sym2=%substr(&g_error,2);
   IF index (logline, "&l_sym1&l_sym2:")   = 1 THEN DO;
      error_count+1;
      PUT '<span style="color:#FF0000">' @;
      PUT '<a name="error' error_count z3. '">' @;
      l = length(logline);
      PUT logline $varying255. l @;
      PUT '</a>'@;
      PUT '</span>';
   END;
%let l_sym1=%substr(&g_warning,1,1);
%let l_sym2=%substr(&g_warning,2);
   ELSE IF index (logline, "&l_sym1&l_sym2:") = 1 THEN DO;
      warning_count+1;
      PUT '<span style="color:#FF8040">' @;
      PUT '<a name="warning' warning_count z3. '">' @;
      l = length(logline);
      PUT logline $varying255. l @;
      PUT '</a>' @;
      PUT '</span>';
   END;
   ELSE DO; 
      /*Ersetzung der Zeichen <, > mit entsprechenden HTML-Codes*/
      DO WHILE (index(logline, '<') > 0);
         textpos = index(logline, '<');
         IF textpos NE 1 THEN
            newlogline = substr(logline, 1, (textpos - 1)) ||'&lt;'||substr(logline, (textpos +length('<')));
         ELSE
            newlogline = '&lt;'||substr(logline, (textpos + length('<')));
         logline = newlogline;
      END;
 
      DO WHILE (index(logline, '>') > 0);
         textpos = index(logline, '>');
         IF textpos NE 1 THEN
            newlogline = substr(logline, 1, (textpos - 1)) ||'&gt;'||substr(logline, (textpos +length('>')));
         ELSE
            newlogline = '&gt;'||substr(logline, (textpos + length('>')));
         logline = newlogline;
      END;
      /*Ausgabe in HTML-Datei*/
      l = length(logline);
      PUT logline $varying255. l;
   END;
   
   IF eof THEN DO;
      PUT '</pre>';
      PUT '</body>';
      PUT '</html>';
   END;
RUN;
%IF %_sasunit_handleError(&l_macname, ErrorWriteHTML, 
   &syserr NE 0, 
   Fehler beim Schreiben der HTML-Datei) 
   %THEN %GOTO errexit;

%IF &l_error_count > 0 %THEN %LET &r_rc = 2;
%ELSE %IF &l_warning_count > 0 %THEN %LET &r_rc = 1;
%ELSE %LET &r_rc=0;

%GOTO exit;
%errexit:
%exit:
%MEND _sasunit_reportLogHTML;

/** \endcond */
