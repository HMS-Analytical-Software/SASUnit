/** 
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Creates test subfolders.

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
            
   \param   i_assertType Type of assert for which the subfolder should be returned
   \param   i_root       path to which the folder should be appended <em>(optional: Default=%sysfunc(pathname(testout)))</em>
   \param   i_scnid      Current scenario id
   \param   i_casid      Current test case is
   \param   i_tstid      Current assert id
   \retval  r_path       Complete absolute path for test outputs

*/ /** \cond */ 
%macro _createTestSubfolder (i_assertType=
                            ,i_root      =%sysfunc(pathname(tempout))
                            ,i_scnid     =
                            ,i_casid     =
                            ,i_tstid     =
                            ,r_path      =
                            );

   %local l_path_cts;
   %let l_path_cts=_ERROR_;

   %if %nrbquote (&r_path.) = %str() %then %do;
      %_issueErrorMessage (&g_currentLogger.,_createTestSubfolder: Please specify a value for r_path.);
      %RETURN;
   %end;
   %if not %symexist(&r_path.) %then %do;
      %_issueErrorMessage (&g_currentLogger.,_createTestSubfolder: Macrovariable for return of subfolder path was not declared by a %nrstr(%%)local-statement.);
      %RETURN;
   %end;
   %let &r_path.=_ERROR_;

   %_getTestSubfolder (i_assertType=&i_assertType.
                      ,i_root      =&i_root.
                      ,i_scnid     =&i_scnid.
                      ,i_casid     =&i_casid.
                      ,i_tstid     =&i_tstid.
                      ,r_path      =l_path_cts
                      );

   %if (%nrbquote(&l_path_cts.) = _ERROR_) %then %do;
      %RETURN;
   %end;

   %_mkdir (&l_path_cts.);

   %let &r_path.=&l_path_cts.;
%mend;
/** \endcond */