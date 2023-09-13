/**
   \file
   \ingroup    SASUNIT_EXAMPLES_PGM

   \brief      Create combined dataset for a database

            
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
