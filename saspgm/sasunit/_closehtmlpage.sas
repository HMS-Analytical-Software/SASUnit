/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      This macro is part of the HTML speedup solution and "closes" an open HTML page. 

               With SAS 9.2 came the possibility to use HTML4 which supports the new inline formatting \n
			   syntax ^{style [<style-statements>]Text}. It is now a tagset and no more a programmed destination\n
			   like HTML3. Opening the destination takes up to several seconds.
			   
			   Key concept of speeding up the creation of HTML4 pages is to keep the destination open. You can easily\n
			   switch documents by specifying ODS HTML file="...". Both html pages the old one that is not explicity closed.\n
			   and the new one that will be opened, comply fully to HTML standard.
			   
			   _OpenDummyHtml.sas open a dummy HTML page that will be left open through the runtime of reportSASUnit.sas.
			   _CloseHtmlPage.sas redirects the destination to the dummy html page.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%macro _closehtmlpage;
   %_openDummyHtmlPage;
%mend;
/** \endcond */