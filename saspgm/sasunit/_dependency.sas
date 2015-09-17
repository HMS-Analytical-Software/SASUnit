/**
   \file
   \ingroup    SASUNIT_UTIL
   \brief      The macro creates two .json files for every macro in the autocall libraries. Based on these .json
               files the visualization of the call hierarchy is achieved using the D3.js library.
               The macro takes two data sets (listcalling and dir) created by the macro _crossreference.sas as input.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param      i_dependencies    Data set containing all dependencies with columns caller and called. In the context
                                 of SASUnit this will be the data set listcalling.
   \param      i_macroList       A data set with the column membername containing the names of macros in the autocall libraries.
                                 For all of these files .json files will be created.

*/ /** \cond */ 

%MACRO _dependency(i_dependencies =
                  ,i_macroList    = dir
                  );

   %LOCAL l_countObs l_name l_children; 

   %** get number of obs;
   PROC SQL noprint;
      select count(*)
      into :l_countObs
      from &i_macroList.
      ;
   QUIT;

   /* initiate loop over all macros referenced in data set */
   %DO l_i=1 %TO &l_countObs;
      /* get libref and dataset name for dataset you will work on during this iteration */
      DATA _NULL_;
         * read one observation;
         SET &i_macroList. (firstobs=&l_i. obs=&l_i.); 
         CALL SYMPUT("l_name", trim(name));
      RUN;

      /* Create Json for calling hierachy (macros called by A) */
      FILENAME json_out "&g_target/tst/crossreference/&l_name._caller.json";
      DATA _NULL_;
         FILE json_out;
      RUN;
      /* Call writeJsonNode to write json */
      %_dependency_wr(i_node=&l_name, i_direction=1, i_dependencies=&i_dependencies);
      /* Finalize json by adding curly bracket */
      DATA _NULL_;
         FILE json_out mod;
         PUT "}";
      RUN;

      /* Create Json for calling hierachy in reverse direction (macros that call A) */
      FILENAME json_out "&g_target/tst/crossreference/&l_name._called.json";
      DATA _NULL_;
         FILE json_out;
      RUN;
      /* Call writeJsonNode to write json */
      %_dependency_wr(i_node=&l_name, i_direction=0, i_dependencies=&i_dependencies);
      /* Finalize json by adding curly bracket */
      DATA _NULL_;
         FILE json_out mod;
         PUT "}";
      RUN;
      
      FILENAME json_out;
   %END;
%MEND _dependency;
