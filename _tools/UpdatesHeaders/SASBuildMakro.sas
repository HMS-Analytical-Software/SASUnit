%macro BuildCurrentBranch;

   %local 
      l_repository
      l_branch_file
      l_difftree_file
      l_protcol_file
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
   %let l_default_branch_name = main;
   %let l_repository    =%sysget (GIT_FOLDER);
   libname _gr "&l_repository.";
   %let l_repository    =%sysfunc (pathname(_gr));
   libname _gr clear;
   
   %let l_rootfolder    =%sysget (ROOT_FOLDER);
   libname _rf "&l_rootfolder.";
   %let l_rootfolder    =%sysfunc (pathname(_rf));
   libname _rf clear;

   %let l_branch_file   =%sysfunc(pathname(work))/branch_file.txt;
   %let l_diff_file     =%sysfunc(pathname(work))/diff_file.txt;
   %let l_protocol_file =&l_rootfolder./SASMakroBuild_Run;
   %let l_temp          =%sysfunc (putn (%sysfunc(today()), YYMMDDn8.));
   %let l_protocol_file =&l_protocol_file._&l_temp;
   %let l_temp          =%sysfunc (compress (%sysfunc (putn (%sysfunc(time()), TIME8.)),:));
   %let l_protocol_file =&l_protocol_file._&l_temp..log;
   %let l_exit          =0;

   %put _local_;

   /*** Retrieving name of the current branch ***/
   /*** If it is in default branch then stop working  ***/
   data _null_;
      length cmd $500;
      cmd = "cd &l_repository." !! ' && ' !! "git status > &l_branch_file.";
      rc =system (cmd);
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
      cmd = "cd ""&l_repository."" && git merge-base &l_default_branch_name. &l_branchName. > ""&l_diff_file.""";
      rc =system (cmd);
   run;

   data _null_;
      length commit_id $80;

      file "&l_protocol_file." MOD;
      infile "&l_diff_file.";

      input;

      put " ";
      commit_id = scan (_INFILE_, 1, " ");
      put "Last common commit of &l_default_branch_name. and branch &&l_branchName. is: " commit_id;
      call symputx ("L_COMMON_COMMIT_ID", commit_id, 'L');
   run;

   /*** Get all touched files between common commit and head of the current branch ***/
   data _null_;
      length cmd $500;
      /***
         perhaps later use this command
         cmd = "cd ""&l_repository."" && git log &l_common_commit_id...HEAD --raw"; 
         it delivers more information e.g. commit id, but is harder to digest
      */
      cmd = "cd ""&l_repository."" && git diff --name-status --diff-filter=AM &l_common_commit_id. > ""&l_diff_file.""";
      rc =system (cmd);
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

            infile "&l_repository.\&&l_program&l_i.." RECFM=N LRECL=1048576 SHAREBUFFERS BLKSIZE=32768;
            file "&l_repository.\&&l_program&l_i.." RECFM=N LRECL=32768 BLKSIZE=1048576;

            dtstring        = catx (" ", put (date(), YYMMDDd10.), put (time(), time8.), "(" !! put (date(), nldatewn.) !! ",",  put (date(), nldate.) !! ")");
            RegExId_Version = prxparse("s/\$Revision.*\$/\$Revision: GitBranch: &l_branchName. \$/i");
            RegExId_Author  = prxparse("s/\$Author.*\$/\$Author: &SYSUSERID. \$/i");
            RegExId_Date    = prxparse("s/\$Date.*\$/\$Date: " !! trim(dtstring) !! " \$/i");

            input line $char32767.;

			putlog line=;
			putlog RegExId_Version=;
			
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
%mend BuildCurrentBranch;

/*
options 
   SET=GIT_FOLDER "C:\TEMP\GitTest_SVN"
   SET=ROOT_FOLDER "C:\Projekte\Git Test"
   ;
*/
%BuildCurrentBranch;


/*
data _null_;
   length text $ 256;
   RegularExpressionId = prxparse('s/\$Revision: GitBranch: GitBashTreeTest $/');
   text = '   \version    \$Revision: GitBranch: GitBashTreeTest $';
   put text;
run;
*/
                          
/*
options xsync noxwait xmin;

   data _null_;
      length cmd $500;
      cmd = "cd ""C:/TEMP/GitTest_SVN"" && git log 0cef75304c1298b818ef2d69771664da1b6cb778..HEAD --raw > ""C:\TEMP\TEST.LOG"""; 
      rc =system (cmd);
   run;

   data work._changed_programs;
      length action $5 commit_id $40 program author date message $256;
      retain action commit_id program author date message "";
      infile "C:\TEMP\TEST.LOG";
      input;
      if (length (_INFILE_) > 1) then do;
         _action = scan (_INFILE_, 1);
         _line1  = substr (_INFILE_, 1, 1);
         if (lowcase (_action) = "commit") then do;
            commit_id = scan (_INFILE_, 2);
         end;
         if (lowcase (_action) = "author:") then do;
            author = scan (_INFILE_, 2, ":");
         end;
         if (lowcase (_action) = "date:") then do;
            date = strip (substr (_INFILE_, 6));
         end;
         if (_line1 = " ") then do;
            message = strip (_INFILE_);
         end;
         if (_line1 = ":") then do;
            program = scan (_INFILE_, 5, " ");
            action  = scan (program, 1, '09x');
            program = scan (program, 2, '09'x);
            output;
         end;
      end;
   run;
*/
