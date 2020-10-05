/**
   \file
   \ingroup    SASUNIT_SETUP

   \brief      Creates an XML log config file for scenarios using a template


   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

   \param      i_projectBinFolder      Path and folder where the binaries for the project are located
   \param      i_scnid                 Scenario ID as three character string padded with leading zeros
   \param      i_sasunitLanguage       Language that is used because it is part of the name of the template file
   \param      o_scnLogConfigfile      Path and name for the resulting XML log config file
*/ /** \cond */
%macro _createScnLogConfigXmlFile(i_projectBinFolder=
                                 ,i_scnid           =
                                 ,i_sasunitLanguage =
                                 ,o_scnLogConfigfile=
                                 );
   data _null_;
      infile "&i_projectBinFolder./sasunit.scnlogconfig.&i_sasunitLanguage..template.xml";
      file   "&o_scnLogConfigfile.";
      input;
      _INFILE_=tranwrd (_INFILE_, "<SCNID>", "&i_scnid.");
      put _INFILE_;
   run;                             
%mend _createScnLogConfigXmlFile;
/** \endcond */