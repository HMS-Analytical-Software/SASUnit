/**
\file
\ingroup    SASUNIT_EXAMPLES_PGM

\brief      Create combined dataset for a database

            
\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%MACRO combineddataset;

   proc sql noprint;
      create table work.combineddataset as
         select  CustomerName
                ,Customer.CustomerNumber
                ,Contracts.ContractNumber
                ,ContractType
         from work.Customer left join work.CustomerContracts 
         on Customer.CustomerNumber=CustomerContracts.CustomerNumber
         left join work.Contracts on CustomerContracts.ContractNumber=Contracts.ContractNumber;
   quit;

%MEND combineddataset;
/** \endcond */
