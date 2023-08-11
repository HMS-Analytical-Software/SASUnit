/**
   \file
   \ingroup    SASUNIT_EXAMPLES_PGM

   \brief      Creation of example data for comparison test - example for SASUnit

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 

%MACRO comparison;
   DATA _NULL_;
      FILE "&g_work./text1.txt";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt";
      PUT "ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo";
      PUT "dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut";
      PUT "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores";
      PUT "et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
   RUN;
   
   DATA _NULL_;
      FILE "&g_work./text1_copy.txt";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt";
      PUT "ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo";
      PUT "dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut";
      PUT "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores";
      PUT "et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
   RUN;
   
   DATA _NULL_;
      FILE "&g_work./text2.txt";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt";
      PUT "ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo";
      PUT "Dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
      PUT "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut";
      PUT "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores";
      PUT "et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
   RUN;
   
   data work.testdata1;
      x = 1;
      y=2;
      Output;
      do i=1 to 9;
         x = i+1;
         if mod(i,2)then DO;
            y = y + 2;
         end;
         else DO;
            y = y - 1;
         end;
         drop i;
         output;
      end;
   run;

   data work.testdata2;
      set testdata1;
      if _n_ = 4 then DO;
         y=7;
      end;
   run;
%MEND comparison;

/** \endcond */
