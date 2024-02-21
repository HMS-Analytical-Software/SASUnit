/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      Updating headers in all touched programs of the current branch compared to default branch

   \version    \$Revision: GitBranch: feature/update-user-and-version-in-sas-programs $
   \author     \$Author: landwich $
   \date       \$Date: 2024-02-21 10:57:02 (Mi, 21. Februar 2024) $
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
*/
%macro BuildCurrentBranch;

   %local 
      l_repository
      l_branch_file
      l_difftree_file
      l_protocol_file
      l_temp
      l_exit
      l_i
      l_suffix
      l_rootfolder
      l_common_commit_id
	  l_default_branch_name
	  l_branchname
	  l_regex_branchname
   ;

   %let l_default_branch_name = master;
   %let l_repository    =%sysget (GIT_FOLDER);
   libname _gr "&l_repository.";
   %let l_repository    =%sysfunc (pathname(_gr));
   libname _gr clear;
   
   %let l_rootfolder    =%sysget (ROOT_FOLDER);
   libname _rf "&l_rootfolder.";
   %let l_rootfolder    =%sysfunc (pathname(_rf));
   libname _rf clear;

   %let l_default_file  =%sysfunc(pathname(work))/default_file.txt;
   %let l_branch_file   =%sysfunc(pathname(work))/branch_file.txt;
   %let l_diff_file     =%sysfunc(pathname(work))/diff_file.txt;
   %let l_protocol_file =&l_rootfolder./SASMakroBuild_Run;
   %let l_temp          =%sysfunc (putn (%sysfunc(today()), YYMMDDn8.));
   %let l_protocol_file =&l_protocol_file._&l_temp;
   %let l_temp          =%sysfunc (compress (%sysfunc (putn (%sysfunc(time()), TIME8.)),:));
   %let l_protocol_file =&l_protocol_file._&l_temp..log;
   %let l_exit          =0;
   %let l_add_file_list =%sysfunc(pathname(work))/add_file_list.txt;
   %let l_add_file_list =./add_file_list.txt;

   options xsync noxwait;

   /*** Get name of default branch ***/
   data _null_;
      length cmd $500;
      cmd = "cd &l_repository." !! ' && ' !! "git symbolic-ref --short refs/remotes/origin/HEAD > ""&l_default_file.""";
      rc =system (cmd);
      if rc ne 0 then do;
         abort 11;
      end;
   run;
   
   data _null_;
      length default_branch_name $256;

      infile "&l_default_file.";
      input default_branch_name $;
      default_branch_name = scan (default_branch_name,2,'/');
      if (_N_ = 1) then do;
         call symputx ("l_default_branch_name", default_branch_name, 'L');
         stop;
      end;
   run;
   
   /*** Retrieving name of the current branch ***/
   /*** If it is in default branch then stop working  ***/
   data _null_;
      length cmd $500;
      cmd = "cd &l_repository." !! ' && ' !! "git status > ""&l_branch_file.""";
      rc =system (cmd);
      if rc ne 0 then do;
         abort 11;
      end;
   run;

   data _null_;
      length branchname $256;

      file "&l_protocol_file.";
      infile "&l_branch_file.";

      input;

      if (_N_ = 1) then do;
         put "This file is &l_protocol_file";
         put " ";
         put "Checking repository in folder: &l_repository.";
         if (index (upcase (_INFILE_), "BRANCH")) then do;
            branchname = scan (_INFILE_, 3, " ");
            put "Current repository is: " branchname;		 
			regex_branchname = tranwrd (branchname, '/', '/');
            call symputx ("L_BRANCHNAME", branchname, 'L');
            call symputx ("L_REGEX_BRANCHNAME", regex_branchname, 'L');
            if (index (upcase (_INFILE_), "%upcase(&l_default_branch_name.)")) then do;
               put "Current repository is default branch, so no action takes place.";
               put " ";
               put "End of logfile";
               call symputx ("LEXIT", "1", 'L');
            end;
			stop;
         end;
      end;
   run;

   %if (&l_exit.) %then %do;
      endsas;
   %end;

   /*** Retrieve last common commit of default and feature branch to get all touched programs ***/
   data _null_;
      length cmd $500;
      cmd = "cd ""&l_repository."""  !! ' && ' !! "git merge-base &l_default_branch_name. &l_branchName. > ""&l_diff_file.""";
      rc =system (cmd);
      if rc ne 0 then do;
         abort 11;
      end;
   run;

   data _null_;
      length commit_id $80;

      file "&l_protocol_file." MOD;
      infile "&l_diff_file.";

      input;

      put " ";
      commit_id = scan (_INFILE_, 1, " ");
      put "Last common commit of &l_default_branch_name. and branch &l_branchName. is: " commit_id;
      call symputx ("L_COMMON_COMMIT_ID", commit_id, 'L');
   run;

   /*** Get all touched files between common commit and head of the current branch ***/
   data _null_;
      length cmd $500;
      /***
         perhaps later use this command
         cmd = "cd ""&l_repository.""" !! ' && ' !! "git log &l_common_commit_id...HEAD --raw"; 
         it delivers more information e.g. commit id, but is harder to digest
      */
      cmd = "cd ""&l_repository.""" !! ' && ' !! "git diff --name-status --diff-filter=AM &l_common_commit_id. > ""&l_diff_file.""";
      rc =system (cmd);
      if rc ne 0 then do;
         abort 11;
      end;
   run;

   data work._changed_programs;
      length action $5 program $256;
      file "&l_protocol_file." MOD;
      infile "&l_diff_file.";
      if (_N_ = 1) then do;
         put " ";
         put "These changed programs are found:";
      end;
      input;
      put _INFILE_;
      action  = scan (_INFILE_, 1, "09"x);
      program = scan (_INFILE_, 2, "09"x);
   run;

   data _null_;
      length program $256;
      file "&l_add_file_list.";
      infile "&l_diff_file.";
      input;
      program = scan (_INFILE_, 2, "09"x);
      put program;
   run;

   /*** Start loop over alle programs ***/
   proc sql noprint;
      select count (*) into :l_changed_programs from work._changed_programs;
      select program into :l_program1- from work._changed_programs;
   quit;

   %do l_i = 1 %to &l_changed_programs.;
      %let l_suffix = %sysfunc(scan (&&l_program&l_i.., -1, .));
      %if (%qupcase(&l_suffix.) ne %qupcase(sas)) %then %do;
         data _NULL_;
            file "&l_protocol_file." MOD;
            put " ";
            put "-------------------------------------------------------------------------------";
            put "---- File &l_i.: &&l_program&l_i..";
            put "---- No SAS program file";
            put "-------------------------------------------------------------------------------";
         run;
      %end;
      %else %do;
         data _NULL_;
            file "&l_protocol_file." MOD;
            put " ";
            put "-------------------------------------------------------------------------------";
            put "---- File &l_i.: &&l_program&l_i..";
            put "---- Starting modification of sas program file";
         run;

         data _NULL_;
            length line $32767 dtstring $80;

            infile "&l_repository./&&l_program&l_i.." RECFM=N LRECL=1048576 SHAREBUFFERS BLKSIZE=32768;
            file "&l_repository./&&l_program&l_i.." RECFM=N LRECL=32768 BLKSIZE=1048576;

            dtstring        = catx (" ", put (date(), YYMMDDd10.), put (time(), time8.), "(" !! put (date(), nldatewn.) !! ",",  put (date(), nldate.) !! ")");
            RegExId_Version = prxparse("s/\$Revision: GitBranch: test/featurebranch $/i");
            RegExId_Author  = prxparse("s/\$Author: landwich $/i");
            RegExId_Date    = prxparse("s/\$Date: 2024-02-21 10:57:02 (Mi, 21. Februar 2024) $/i");

            input line $char32767.;

            call prxchange(RegExId_Version, -1, line);
            call prxchange(RegExId_Author, -1, line);
            call prxchange(RegExId_Date, -1, line);

            put line $;
         run;

         data _NULL_;
            file "&l_protocol_file." MOD;
            put " ";
            put "---- Finished modifications of sas program file";
            put "-------------------------------------------------------------------------------";
         run;
      %end;
   %end;

   data _NULL_;
      file "&l_protocol_file." MOD;
      put " ";
      put "End of logfile";
   run;
   
   data _null_;
      cmd = "cd ""&l_repository.""" !! ' && ' !! " git add --pathspec-from-file=""&l_add_file_list.""";
      rc =system (cmd);
      if rc ne 0 then do;
         abort 11;
      end;
      cmd = "cd ""&l_repository.""" !! ' && ' !! " git commit -m ""Automatically update headers""";
      rc =system (cmd);
      if rc ne 0 then do;
         abort 11;
      end;
   run;
%mend BuildCurrentBranch;

%BuildCurrentBranch; 