libname tmp "%sysget (SASUNIT_ROOT)";
%let g_sasunitRootPath = %sysfunc(pathname(tmp));
libname tmp clear;

libname tmp "%sysget (SASUNIT_TOOL_ROOT)";
%let g_toolRootPath = %sysfunc(pathname(tmp));
libname tmp clear;

%include "&g_toolRootPath.\_createbatchfile_win.sas";
%include "&g_toolRootPath.\_createbatchfiles.sas";
%include "&g_toolRootPath.\_createconfigfile.sas";
%include "&g_toolRootPath.\_createlogconfigfile.sas";
%include "&g_toolRootPath.\_createscnlogconfigtemplate.sas";
%include "&g_toolRootPath.\sasunitsetup.sas";

%let os          =%sysget (SASUNIT_HOST_OS);

options SASAUTOS=(SASAUTOS "&g_sasunitRootPath.\saspgm\sasunit" "&g_sasunitRootPath.\saspgm\sasunit\%lowcase(&os.)");

options mrecall mprint;

*** Windows SASUnit ***;
%let jenkinsPath =&g_sasunitRootPath.;
%let sasPath     =%sysget (SASUNIT_SAS_PATH);
%let language    =DE;
%let version     =%sysget (SASUNIT_SAS_VERSION);
%let targetFolder=&jenkinsPath.\bin;

%SASUnitSetup(i_sasunitRootFolder  =&g_sasunitRootPath.
             ,i_projectRootFolder  =&jenkinsPath.
             ,i_sasunitLogPath     =&jenkinsPath./doc/sasunit/%lowcase(&language.)
             ,i_sasunitScnLogPath  =&jenkinsPath./doc/sasunit/%lowcase(&language.)/log
             ,i_sasunitTestDBFolder=&jenkinsPath./doc/sasunit/%lowcase(&language.)
             ,i_projectBinFolder   =bin
             ,i_sasunitLanguage    =&language.
             ,i_sasunitRunAllPgm   =&jenkinsPath./saspgm/test/run_all.sas
             ,i_operatingSystem    =&os.
             ,i_sasVersion         =&version.
             ,i_sasexe             =&sasPath.\&version.\sas.exe
             ,i_sasconfig          =&sasPath.\&version.\nls\%lowcase(&language.)\SASV9.CFG
             );

%let language    =EN;

%SASUnitSetup(i_sasunitRootFolder  =&g_sasunitRootPath.
             ,i_projectRootFolder  =&jenkinsPath.
             ,i_sasunitLogPath     =&jenkinsPath./doc/sasunit/%lowcase(&language.)
             ,i_sasunitScnLogPath  =&jenkinsPath./doc/sasunit/%lowcase(&language.)/log
             ,i_sasunitTestDBFolder=&jenkinsPath./doc/sasunit/%lowcase(&language.)
             ,i_projectBinFolder   =bin
             ,i_sasunitLanguage    =&language.
             ,i_sasunitRunAllPgm   =&jenkinsPath./saspgm/test/run_all.sas
             ,i_operatingSystem    =&os.
             ,i_sasVersion         =&version.
             ,i_sasexe             =&sasPath.\&version.\sas.exe
             ,i_sasconfig          =&sasPath.\&version.\nls\%lowcase(&language.)\SASV9.CFG
             );

*** Windows Examples ***;
%let jenkinsPath =&g_sasunitRootPath./example;
%let sasPath     =%sysget (SASUNIT_SAS_PATH);
%let language    =DE;
%let version     =%sysget (SASUNIT_SAS_VERSION);
%let targetFolder=&jenkinsPath.\bin;

%SASUnitSetup(i_sasunitRootFolder  =&g_sasunitRootPath.
             ,i_projectRootFolder  =&jenkinsPath.
             ,i_sasunitLogPath     =&jenkinsPath./doc/sasunit/%lowcase(&language.)
             ,i_sasunitScnLogPath  =&jenkinsPath./doc/sasunit/%lowcase(&language.)/log
             ,i_sasunitTestDBFolder=&jenkinsPath./doc/sasunit/%lowcase(&language.)
             ,i_projectBinFolder   =bin
             ,i_sasunitLanguage    =&language.
             ,i_sasunitRunAllPgm   =&jenkinsPath./saspgm/run_all.sas
             ,i_operatingSystem    =&os.
             ,i_sasVersion         =&version.
             ,i_sasexe             =&sasPath.\&version.\sas.exe
             ,i_sasconfig          =&sasPath.\&version.\nls\%lowcase(&language.)\SASV9.CFG
             );

%let language    =EN;

%SASUnitSetup(i_sasunitRootFolder  =&g_sasunitRootPath.
             ,i_projectRootFolder  =&jenkinsPath.
             ,i_sasunitLogPath     =&jenkinsPath./doc/sasunit/%lowcase(&language.)
             ,i_sasunitScnLogPath  =&jenkinsPath./doc/sasunit/%lowcase(&language.)/log
             ,i_sasunitTestDBFolder=&jenkinsPath./doc/sasunit/%lowcase(&language.)
             ,i_projectBinFolder   =bin
             ,i_sasunitLanguage    =&language.
             ,i_sasunitRunAllPgm   =&jenkinsPath./saspgm/run_all.sas
             ,i_operatingSystem    =&os.
             ,i_sasVersion         =&version.
             ,i_sasexe             =&sasPath.\&version.\sas.exe
             ,i_sasconfig          =&sasPath.\&version.\nls\%lowcase(&language.)\SASV9.CFG
             );

