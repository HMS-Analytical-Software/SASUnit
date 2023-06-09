/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Switch macro to switch between example database and real database

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%macro _switch();
   %global state save_root save_target;
   %if &state= or &state=0 %then %do;
      %let state=1;
      %let save_root=&g_root;
      %let save_target=&g_target;
      %let g_root=&g_work;
      %let g_target=&g_work;
   %end;
   %else %do;
      %let state=0;
      %let g_root=&save_root;
      %let g_target=&save_target;
   %end;
   libname target "&g_target";
%mend _switch;
/** \endcond */