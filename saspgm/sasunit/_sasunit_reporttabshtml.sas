/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create tabs on HTML page for report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_tabnames     tab labels, in quotes and separated by blanks
   \param   i_pages        page names for hyperlinks for each tab, in quotes and separated by blanks,
                           same number of entries as in i_tabnames
   \param   i_current      number of the active tab, default is 1

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
