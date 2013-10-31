/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _delTempFiles.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

data;
set sashelp.class;
run;

%initTestcase(i_object=_delTempFiles.sas, i_desc=Test with correct call)
%_delTempFiles;
%endTestcall;

%assertTableExists(i_libref=work, i_memname=data1, i_desc=check on table abscence, i_not=1)
%endTestcase;

/** \endcond */
