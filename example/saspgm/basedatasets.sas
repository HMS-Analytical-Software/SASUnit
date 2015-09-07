/**
   \file
   \ingroup    SASUNIT_EXAMPLES_PGM

   \brief      Create base datasets for a database


   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

*/ /** \cond */ 

%MACRO basedatasets;

   data work.Customer;
      do i=1 to 5;
         CustomerNumber=i;
         CustomerName="Customer " !! put (i,z2.);
         output;
      end;
      drop i;
   run;

   data work.Contracts;
      do i=1 to 8;
         ContractNumber=i;
         ContractType=mod (i,3)+1;
         output;
      end;
      drop i;
   run;

   data work.CustomerContracts;
      do i=1 to 8;
         ContractNumber=i;
         CustomerNumber=mod (i,5)+1;
         output;
      end;
      drop i;
   run;

%MEND basedatasets;
/** \endcond */
