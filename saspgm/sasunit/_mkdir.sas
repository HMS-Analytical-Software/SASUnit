/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      create a directory, if it does not exist
               The containing directory must exist. 

               \%mkdir(dir=directory)

               sets &sysrc to a value other than 0, when errors occured.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

   \param dir              Path that shall be created in the file system.
   \param makeCompletePath Flag with value zero or other. If flag is zero then only one subfolder will be created and the parent folder has to exist.
                           Parent folder is the folder right next to the last folder in given path.
                           If flag is unequal to zero then all missing folders in the path will be created.
   
   \test New test calls that catch all messages
   \todo Delete os-dependant macros
*/ /** \cond */

%macro _mkdir (dir
              ,makeCompletePath = 0
              );
              
      %local
         l_result
         l_osPath
         l_folderName
         l_parentFolder
      ;

      %let l_result=1;
      
      %let l_osPath = %_makeSASUnitPath(&dir.);
      
      /*** Checking if path already exists, then there is nothing to do ***/
      %if (%sysfunc (fileexist (&l_osPath.))) %then %do;
         %_issueInfoMessage (&g_currentLogger.,_mkdir: Folder &l_osPath. already exists.);
         %goto exit;
      %end;
      
      /*** Checking if parentfolder exists, for error message only. ***/
      %let l_folderName    = %sysfunc (scan (&l_osPath., -1, /));
      %let l_parentFolder  = %substr  (&l_osPath., 1, %eval(%length (&l_osPath.)-%length (&l_folderName.)-1));

      %if (&makeCompletePath. = 0) %then %do;
         %if (not %sysfunc (fileexist (&l_parentFolder.))) %then %do;
            %_issueErrorMessage (&g_currentLogger.,_mkdir: Parentfolder &l_parentFolder. does not exist.);
            %goto exit;
         %end;
      %end;
      
      /*** Dir contains complete path ***/
      data _null_;
         length 
            osPath ParentFolder Directory NewDirectory $32000
            FolderName $256
            osPathPrefix $2;            
         ;

         osPath       = "&l_osPath.";
         osPathPrefix = "";
         *** Let all paths start with /                                 ***;
         *** Cut off and remember volumename when running under windows ***;
         if (index (osPath,':')) then do;
            osPathPrefix = scan (osPath, 1, '/');
            osPath       = scan (osPath, 2, ':');
         end;
         
         numOfFolders = count (osPath, "/");
         ParentFolder = catt (osPathPrefix, "/", scan (osPath, 1, "/"));
         do i=2 to numOfFolders;
            FolderName   = scan(osPath, i, "/");
            Directory    = catx ("/", ParentFolder, FolderName);
            if (not fileexist (Directory)) then do;
               NewDirectory = dcreate (FolderName, ParentFolder);
               if (not fileexist (NewDirectory)) then do;
                  call symputx ("l_folderName", catt(FolderName), 'L');
                  call symputx ("l_parentFolder", catt(ParentFolder), 'L');
                  leave;
               end;
            end;
            ParentFolder = Directory;
            call symputx ("l_result", catt(ParentFolder), 'L');
         end;
      run;

      %if (%bquote(&l_result.) = 1) %then %do;
         %_issueErrorMessage (&g_currentLogger.,_mkdir: Folder &l_folderName. could not be created in directory &l_parentFolder..);
      %end;
      %if (%bquote(&l_result.) = %bquote (&l_osPath.)) %then %do;
         %if (&makeCompletePath. ne 0) %then %do;
            %_issueInfoMessage (&g_currentLogger.,_mkdir: FolderTree &l_osPath. sucessfully created.);
         %end;
         %else %do;
            %_issueInfoMessage (&g_currentLogger.,_mkdir: Folder &l_folderName. sucessfully created.);
         %end;
      %end;

   %exit:
   
%mend _mkdir; 

/** \endcond */
