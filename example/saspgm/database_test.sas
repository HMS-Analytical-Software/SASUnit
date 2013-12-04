/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests for buidling a database

            Example for a test scenario with the following features: 

\version    \$Revision$ - KL: Newly created
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */

/*-- Creation of base dataets -----------------------------------------*/
%initTestcase(i_object=basedatasets.sas, i_desc=Creation of base datasets)
%basedatasets
%endTestCall()

%assertTableExists (i_libref =work
                   ,i_memname=customer
                   ,i_desc   =Table was successfuly created?
                   )
%assertRecordCount (i_libref    =work
                   ,i_memname   =customer
                   ,i_recordsExp=5
                   ,i_desc      =Does table contain all expected Rows?
                   )
%assertPrimaryKey (i_library  =work
                  ,i_dataset  =customer
                  ,i_variables=CustomerNumber
                  ,i_desc     =Is the generated key unique?
                  )

%assertTableExists (i_libref =work
                   ,i_memname=contracts
                   ,i_desc   =Table was successfuly created?
                   )
%assertRecordCount (i_libref    =work
                   ,i_memname   =contracts
                   ,i_recordsExp=8
                   ,i_desc      =Does table contain all expected Rows?
                   )
%assertPrimaryKey (i_library  =work
                  ,i_dataset  =contracts
                  ,i_variables=ContractNumber)

%assertRecordExists (i_dataset  =work.Contracts
                    ,i_whereExpr=%str(ContractType=1)
                    ,i_desc     =Do we have at least one record per contract type?
                    );
%assertRecordExists (i_dataset  =work.Contracts
                    ,i_whereExpr=%str(ContractType=2)
                    ,i_desc     =Do we have at least one record per contract type?
                    );
%assertRecordExists (i_dataset  =work.Contracts
                    ,i_whereExpr=%str(ContractType=3)
                    ,i_desc     =Do we have at least one record per contract type?
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
%endTestCase()
*/
/** \endcond */
