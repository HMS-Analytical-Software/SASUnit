/** \file
   \ingroup    SASUNIT_REPORT

   \brief      

   \version    \$Revision: 260 $
   \author     \$Author: klandwich $
   \date       \$Date: 2013-09-08 20:47:54 +0200 (So, 08 Sep 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_render_assertcolumnsact.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn 
   \param   o_targetColumn 
   \param   
   \param   
   \param   
   \param   
   

*/ /** \cond */ 

%macro _render_crossrefColumn (i_sourceColumn       =
                              ,o_targetColumn       =
                              ,i_linkColumn_caller  =
                              ,i_linkTitle_caller   =
                              ,i_linkColumn_called  =
                              ,i_linkTitle_called   =
                              );
   len = length(trim(cas_pgm));
   cas_pgm_strip = substrn(cas_pgm, 1, len-4);
   
   href_caller     = "crossref.html?casPgm="||trim(cas_pgm_strip)||'%nrstr(&)call=caller';
   href_called     = "crossref.html?casPgm="||trim(cas_pgm_strip)||'%nrstr(&)call=called';

   &o_targetColumn. = catt ('^{style [flyover="', &i_linkTitle_caller., '" url="' !! href_caller !! '"] ', &i_linkColumn_caller.,'} ^n ');
   &o_targetColumn. = catt (&o_targetColumn., '^{style [flyover="', &i_linkTitle_called., '" url="' !! href_called !! '"] ', &i_linkColumn_called., '}');
   
%mend _render_crossrefColumn;
/** \endcond */
