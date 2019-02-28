/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Copy macros source codes to rep directory, so that they can be accessed even when rep folder is moved.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param    i_logfile  complete path and name of logfile
   \param    i_error    symbol for error (normally error, but might be language dependant). The value will be converted to uppercase.
   \param    i_warning  symbol for warning (normally warning, but might be language dependant). The value will be converted to uppercase.
   \param    r_errors   macro variable to return number of errors (999 if logfile does not exist)
   \param    r_warnings macro variable to return number of warnings (999 if logfile does not exist)

*/
/** \cond */ 
%MACRO _copyMacrosToRepSrc (o_pgmdoc_sasunit=);

   %local l_output_path l_rc l_saspgm;

   data work._exa;
      set target.exa;
      *** Files not residing in an autocall path will have . as exa_auton ***;
      *** Use 99 as an alternative                                        ***;
      exa_auton = coalesce (exa_auton, 99);
   run;

   proc sort data=work._exa;
      by exa_auton exa_pgm;
   run;

   %let l_output_path = %_abspath(&g_root., &g_target.)/rep;
   %let l_rc          = %sysfunc (dcreate (src, &l_output_path.));
   %let l_output_path = &l_output_path./src;
   %let l_saspgm      = %sysfunc(pathname(work))/CopyMacrosToRep.sas;
   data _null_;
      file "&l_saspgm.";
      set work._exa;
      length command $32000 NewDir DirRc $300;
      Retain NewDir;
      by exa_auton;
      if (first.exa_auton) then do;
         NewDir = "&l_output_path./" !! put (exa_auton, z2.);
         DirRc  = dcreate (put (exa_auton, z2.), "&l_output_path.");
      end;
      command = catt ('%_copyfile(', exa_filename, ",", NewDir, "/", exa_pgm, ");");
      put command;
   run;
   %include "&l_saspgm.";

   proc sort data=target.scn out=work._scn;
      by scn_id;
   run;

   %let l_output_path = %_abspath(&g_root., &g_target.)/rep/src;
   %let l_rc          = %sysfunc (dcreate (scn, &l_output_path.));
   %let l_output_path = &l_output_path./scn;
   %let l_saspgm      = %sysfunc(pathname(work))/CopyMacrosToRep.sas;

   data _null_;
      file "&l_saspgm.";
      set work._scn;
      length command $32000 scn_abs_path $300;
      scn_abs_path = resolve ('%_abspath(&g_root,' !! trim(scn_path) !! ')');
      command = catt ('%_copyfile(', scn_abs_path, ", &l_output_path./scn_", put (scn_id, z3.) , ".sas);");
      put command;
   run;
   %include "&l_saspgm.";
%MEND _copyMacrosToRepSrc;
/** \endcond */
