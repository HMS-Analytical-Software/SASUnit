/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests for building a database

            Example for a test scenario with the following features:
            - Creating three tables for bulding up a sample database.
            - These are the created tables:
               - Customer\n Table containing 5 customers.\n Variables are CustomerNumber and CustomerName.\n
                 Primary key ist CustomerNumber.
               - Contracts\n Table containing 8 contracts.\n Variales are ContractNumer and ContractType.\n
                 Primary key is ContractNumber. ContractType should range from 1 to 3.
               - CustomerContracts\n Table mapping contracts to customers.\n Variables are CustomerNumber and ContractNumber.\n
                 Primary key ist ContractNumber and CustomerNumber.
            - All foreign key relations are checked
            - A combined dataset is created
               - Combined datasets should containg 8 rows.\n Primary key is ContractNumber and CustomerNumber.
               - Checking if there are customers without contracts and vice versa.

   \version    \$Revision: GitBranch: feature/jira-29-separate-SASUnit-files-from-project-source $
   \author     \$Author: landwich $
   \date       \$Date: 2024-03-13 11:25:41 (Mi, 13. M�rz 2024) $

   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */

%initScenario(i_desc=Tests for building a database);

/*-- Creation of base datasets -----------------------------------------*/
%initTestcase(i_object=basedatasets.sas, i_desc=Creation of base datasets)
%basedatasets
%endTestCall()

%assertTableExists (i_libref =work
                   ,i_memname=Customer
                   ,i_desc   =Table was successfuly created?
                   )
%assertRecordCount (i_libref    =work
                   ,i_memname   =Customer
                   ,i_recordsExp=5
                   ,i_desc      =Does table contain all expected Rows?
                   )
%assertPrimaryKey (i_library  =work
                  ,i_dataset  =Customer
                  ,i_variables=CustomerNumber
                  ,i_desc     =Is the generated key unique?
                  )

%assertTableExists (i_libref =work
                   ,i_memname=Contracts
                   ,i_desc   =Table was successfuly created?
                   )
%assertRecordCount (i_libref    =work
                   ,i_memname   =Contracts
                   ,i_recordsExp=8
                   ,i_desc      =Does table contain all expected Rows?
                   )
%assertPrimaryKey (i_library  =work
                  ,i_dataset  =Contracts
                  ,i_variables=ContractNumber)

%assertRecordExists (i_dataset  =work.Contracts
                    ,i_whereExpr=%str(ContractType=1)
                    ,i_desc     =Do we have at least one record per contract type 1?
                    );
%assertRecordExists (i_dataset  =work.Contracts
                    ,i_whereExpr=%str(ContractType=2)
                    ,i_desc     =Do we have at least one record per contract type 2?
                    );
%assertRecordExists (i_dataset  =work.Contracts
                    ,i_whereExpr=%str(ContractType=3)
                    ,i_desc     =Do we have at least one record per contract type 3?
                    );

%assertTableExists (i_libref =work
                   ,i_memname=CustomerContracts
                   ,i_desc   =Table was successfuly created?
                   )
%assertRecordCount (i_libref    =work
                   ,i_memname   =CustomerContracts
                   ,i_recordsExp=8
                   ,i_desc      =Does table contain all expected Rows?
                   )
%assertPrimaryKey (i_library  =work
                  ,i_dataset  =CustomerContracts
                  ,i_variables=ContractNumber CustomerNumber)

%assertForeignKey (i_mstrLib  =work
                  ,i_mstMem   =CustomerContracts
                  ,i_mstKey   =ContractNumber
                  ,i_lookupLib=work
                  ,i_lookupMem=Contracts
                  ,i_lookupKey=ContractNumber
                  ,i_desc     =Check ContractNumber
                  );

%assertForeignKey (i_mstrLib  =work
                  ,i_mstMem   =CustomerContracts
                  ,i_mstKey   =CustomerNumber
                  ,i_lookupLib=work
                  ,i_lookupMem=Customer
                  ,i_lookupKey=CustomerNumber
                  ,i_desc     =Check CustomerNumber
                  );

%assertLog (i_errors=0, i_warnings=0)
%endTestCase()

/*-- Creation of combined table --------------------------------------------*/
%initTestcase(i_object=combineddataset.sas, i_desc=Creating combined dataset)
%combineddataset
%endTestCall()

%assertTableExists (i_libref =work
                   ,i_memname=CombinedDataset
                   ,i_desc   =Table was successfuly created?
                   )
%assertRecordCount (i_libref    =work
                   ,i_memname   =CombinedDataset
                   ,i_recordsExp=8
                   ,i_desc      =Does table contain all expected Rows?
                   )
%assertPrimaryKey (i_library  =work
                  ,i_dataset  =CombinedDataset
                  ,i_variables=ContractNumber CustomerNumber)

%assertRowExpression(i_libref  =work
                    ,i_memname =CustomerContracts
                    ,i_where   =%str(not missing %(ContractNumber%))
                    ,i_desc    =There should be no customers without contracts
                    );

%assertRowExpression(i_libref  =work
                    ,i_memname =CustomerContracts
                    ,i_where   =%str(not missing %(CustomerNumber%))
                    ,i_desc    =There should be no contracts without customer
                    );

%assertLog (i_errors=0, i_warnings=0)
%endTestCase();

proc datasets lib=work nolist;
   delete customer contracts
          customercontracts
		  combineddataset
   ;
run;
quit;

%endScenario();
/** \endcond */
