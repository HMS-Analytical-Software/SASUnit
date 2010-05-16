/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      create german report in separate subfolder

\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/example/saspgm/run_all.sas $
*/ /** \cond */ 


OPTIONS 
   MPRINT MAUTOSOURCE 
   SASAUTOS=(SASAUTOS "c:/projekte/sasunit/saspgm/sasunit") /* SASUnit macro library */
;

/* open test repository */
%initSASUnit(
   i_root       = c:/projekte/sasunit /* root path for convenience, following paths can be relative */
  ,io_target    = example/doc/sasunit /* output of SASUnit: test repository, logs, results, reports */
)

/* create report - always force complete creation */
%reportSASUnit(i_language=DE, o_force=1, o_output=example\doc\sasunit.de)

/** \endcond */
