/** \file
   \ingroup    SASUNIT_REPORT

   \brief      die Tabs auf einer HTML-Seite erstellen

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_tabnames     Bezeichnungen auf den Tabs, in Hochkommata und mit Leerzeichen getrennt
   \param   i_pages        Verweise für die Tabs, in Hochkommata und mit Leerzeichen 
                           getrennt, es muss sich die gleiche Anzahl wie in 
                           i_tabnames ergeben
   \param   i_current      Nummer des aktiven Tabs, Voreinstellung ist 1 (erster Tab)

*/ /** \cond */ 

%MACRO _sasunit_reportTabsHTML (
   i_tabnames
  ,i_pages
  ,i_current = 1
);

   LENGTH _sasunit_reportTabsHTML $256;
   PUT '<div class="tabs">';
   PUT '  <ul>';
%LOCAL i;
%LET i=1;
%DO %WHILE(%sysfunc(scanq(&i_tabnames, &i)) NE );
   _sasunit_reportTabsHTML = %sysfunc(scanq(&i_pages, &i));
   PUT '  <li ' @;
   %IF &i=&i_current %THEN %DO;
      PUT 'class="current"' @;
   %END;
   PUT '><a href="' _sasunit_reportTabsHTML +(-1) @;
   _sasunit_reportTabsHTML = %sysfunc(scanq(&i_tabnames, &i));
   PUT '"><span>' _sasunit_reportTabsHTML +(-1) '</span></a></li>';
   %LET i=%eval(&i+1);
%END;
   PUT '  </ul>';
   PUT '</div>';
   
%MEND _sasunit_reportTabsHTML;
/** \endcond */
