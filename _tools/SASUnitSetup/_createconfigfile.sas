%macro _createConfigFile(i_projectBinFolder =
                        ,i_projectRootFolder=
                        ,i_sasunitLogPath   =
                        ,i_sasunitLanguage  =
                        ,i_sasunitRunAllPgm =
                        ,i_operatingSystem  =
                        ,i_sasVersion       =
                        ,i_sasconfig        =
                        );

   %local
	  l_projectRootFolder
	  l_sasunitRunAllPgm
	  l_sasunitLogPath
	  l_sasconfig
     l_sasunitLogFileName
   ;

   %let l_projectRootFolder   =%sysfunc(translate (&i_projectRootFolder.,/,\));
   %let l_sasunitRunAllPgm    =%sysfunc(translate (&i_sasunitRunAllPgm.,/,\));
   %let l_sasunitLogPath      =%sysfunc(translate (&i_sasunitLogPath.,/,\));
   %let l_sasconfig           =%sysfunc(translate (&i_sasconfig.,/,\));

   %put >>>&=l_sasunitRunAllPgm.;
   
   %let l_sasunitLogPath      =%_stdPath(&l_projectRootFolder., &l_sasunitLogPath.);
   %let l_sasunitRunAllPgm    =%_stdPath(&l_projectRootFolder., &l_sasunitRunAllPgm.);
   %let l_sasunitLogFileName  =%scan (&l_sasunitRunAllPgm., -1, /);
   
   %put >>>&=l_sasunitRunAllPgm.;

   data _NULL_;
      file "&targetFolder./sasunit.&i_sasVersion..&i_operatingSystem..&i_sasunitLanguage..cfg";
      put "/**";
      put "   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.";
      put "               For copyright information and terms of usage under the GPL license see included file readme.txt";
      put "               or https://sourceforge.net/p/sasunit/wiki/readme/.";
      put;
      put "   \author generated by SASUnit through &sysuserid.";
      put "   \date generated on %sysfunc(putn (%sysfunc(datetime()), nldatm.))";
      put "*/";
      put;
      put "-CONFIG ""&l_sasconfig.""";
      put "-sysin ""&l_sasunitRunAllPgm."""; 
	  put "-log ""&l_sasunitLogPath./%sysfunc(tranwrd(&l_sasunitLogFileName., .sas, .log))""";
	  put "-print ""&l_sasunitLogPath./%sysfunc(tranwrd(&l_sasunitLogFileName., .sas, .lst))""";
   run;

%mend _createConfigFile;
