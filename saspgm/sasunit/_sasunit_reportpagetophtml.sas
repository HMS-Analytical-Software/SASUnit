/** \file
   \ingroup    SASUNIT_REPORT

   \brief      den HTML-Header, die benötigten Tabs und die Überschrift erstellen

   \version 1.0
   \author  Andreas Mangold
   \date    18.10.2007
   \param   i_title        Titel der Seite
   \param   i_current      Nummer des aktiven Tabs, Voreinstellung ist 1

*/ /** \cond */ 

/* change log
   19.08.2008 AM  national language support
*/ 

%MACRO _sasunit_reportPageTopHTML (
    i_title   =
   ,i_current = 1
);
      %_sasunit_reportHeaderHTML(&i_title)

      %_sasunit_reportTabsHTML(
          &g_nls_reportPageTop_001
         ,"overview.html" "scn_overview.html" "cas_overview.html" "auton_overview.html"
         ,i_current=&i_current
      )

      PUT "<h1>&i_title</h1>";
   
%MEND _sasunit_reportPageTopHTML;
/** \endcond */
