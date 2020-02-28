/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      Aggregate JSON files to one JavaScript file containing one JSON object

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \remark     still uses _dir. This macro is called by reportSASUnit. reportSASUnit will not be called interactively. 
               So there is no need to change anything with this macro concerning NOXCMD

   \param   i_path      Path containing JSON files that will be aggregated 
   \param   o_file      JavaScript file in doc/js containing a JSON object for visualisation

*/ /** \cond */ 

%MACRO _dependency_agg(i_path =
                      ,o_file =
                      );
                      
                      
                      
   %LOCAL l_countObs json_dir l_pgmName l_filename;
   
   %_tempFileName(json_dir);
   %_dir(i_path   = &i_path
        ,o_out    = &json_dir);

   /* get number of obs */
   PROC SQL NOPRINT;
      SELECT count(*)
      INTO :l_countObs
      FROM &json_dir.
      ;
   QUIT;
   
   FILENAME aggregJS "&o_file";
   
   /* Create JavaScript file */
   DATA _NULL_;
      FILE aggregJS;
      PUT 'var allGraphs = [';
   RUN;
   
   /* initiate loop over all data sets referenced in data set */
   %DO l_i=1 %TO &l_countObs;
   
      DATA _NULL_;
         * read one observation;
         SET &json_dir. (firstobs=&l_i. obs=&l_i.); 
         len = length(membername)-12;
         CALL SYMPUT("l_pgmName", substr(membername,1,len));
         CALL SYMPUT("l_filename", trim(filename));
      RUN;
      
      %IF %EVAL(%SYSFUNC(mod(&l_i,2)) = 1) %THEN %DO;
         DATA _NULL_;
            FILE aggregJS mod;
            helper = catt('{ "id"     :  "', "&l_pgmName", '"');
            put helper;
            put ',   "called" :';
         RUN;
         
         DATA _NULL_;
            INFILE "&l_filename";
            Input;
            FILE aggregJS mod;
            put _infile_;
         RUN;
      %END;
      %ELSE %DO;
         DATA _NULL_;
            FILE aggregJS mod;
            helper = ', "caller" :';
            put helper;
         RUN;
         DATA _NULL_;
            INFILE "&l_filename";
            Input;
            FILE aggregJS mod;
            put _infile_;
         RUN;
      
         DATA _NULL_;
            FILE aggregJS mod;
            helper = "} // " || "&l_pgmName";
            put helper;
            %IF %sysfunc(strip(&l_countObs)) NE %sysfunc(strip(&l_i)) %THEN %DO;
               put ',';
            %END;
         RUN;

      %END;
   %END;
   
   /* Finalize JavaScript file */
   DATA _NULL_;
      FILE aggregJS mod;
      put '];';
   RUN;
   
   FILENAME aggregJS;

%MEND _dependency_agg;
