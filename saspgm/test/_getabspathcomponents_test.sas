/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _getAbsPathComponents.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 
%initScenario (i_desc=Test of _getAbsPathComponents.sas);

/* Testcase 1 ****************************************************************/
%initTestcase(i_object=_getAbsPathComponents.sas
            , i_desc=%str(absolute path is splitted))
%LET r_fileName=;
%LET r_pathWithoutName=;
%_getAbsPathComponents(
                    i_absPath         = C:/temp/test.sas
                  , o_fileName        = r_fileName
                  , o_pathWithoutName = r_pathWithoutName
                   )

%assertLog()
%assertEquals(i_expected=C:/temp , i_actual=&r_pathWithoutName, i_desc=pathWithoutName)
%assertEquals(i_expected=test.sas, i_actual=&r_fileName       , i_desc=fileName)
%endTestcase()

/* Testcase 2 ****************************************************************/
%initTestcase(i_object=_getAbsPathComponents.sas
            , i_desc=%str(only file name is given))
%LET r_fileName=;
%LET r_pathWithoutName=;
%_getAbsPathComponents(
                    i_absPath         = test.sas
                  , o_fileName        = r_fileName
                  , o_pathWithoutName = r_pathWithoutName
                   )

%assertLog()
%assertEquals(i_expected= , i_actual=&r_pathWithoutName, i_desc=pathWithoutName)
%assertEquals(i_expected=test.sas, i_actual=&r_fileName       , i_desc=fileName)
%endTestcase()

%endScenario();
/** \endcond */