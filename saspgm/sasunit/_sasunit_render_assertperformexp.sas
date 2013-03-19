/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the expected column for assertPerformance

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   i_format       name of the format that will be applied to the value. <em>(optional: _NONE_)</em>.
   \param   i_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */ 

/* change log
   14.03.2013 KL  Created
*/ 

%macro _sasunit_render_assertPerformExp (i_sourceColumn=
                                        ,i_format=_NONE_
                                        ,i_targetColumn=
                                        );
   IF (upcase(tst_type) = 'ASSERTPERFORMANCE') THEN DO;
      %_sasunit_render_dataColumn (i_sourceColumn=&i_sourceColumn.
                                  ,i_format      =&i_format.
                                  ,i_targetColumn=&i_targetColumn.
                                  );
   END;
%mend _sasunit_render_assertPerformExp;
/** \endcond */
