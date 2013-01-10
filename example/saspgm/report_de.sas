/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      create german report in separate subfolder

\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 


OPTIONS 
   MPRINT MAUTOSOURCE 
   SASAUTOS=(SASAUTOS "c:/projects/sasunit/saspgm/sasunit") /* SASUnit macro library */
;

/* open test repository */
%initSASUnit(
   i_root       = c:/projects/sasunit /* root path for convenience, following paths can be relative */
  ,io_target    = example/doc/sasunit /* input test repository */
)

/* create report - always force complete creation */
%reportSASUnit(i_language=DE, o_force=1, o_output=example\doc\sasunit.de)

/** \endcond */
