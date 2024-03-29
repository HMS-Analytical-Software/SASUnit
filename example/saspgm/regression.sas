/**
   \file
   \ingroup    SASUNIT_EXAMPLES_PGM

   \brief      Linear regression analysis - example for SASUnit

               Calculate a simple linear regression with intercept for the two variables specified and 
               - write input data and estimated values to the output dataset &out
               - write regression parameters to output dataset &parms
               - generate a report in RTF format containing a plot of predicted and observed values

               This example contains no validation of macro parameters
            
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

   \param      data    input dataset
   \param      x       variable for x axis, must be numeric
   \param      y       variable for y axis, must be numeric
   \param      out     output dataset, contains variables &x, &y and &yhat
   \param      yhat    name of the variable with estimated values
   \param      parms   output dataset with regression parameters
   \param      report  report file (file extension must be .rtf)
*/ /** \cond */ 

%MACRO regression(
   data   =
  ,x      =
  ,y      = 
  ,out    = 
  ,yhat   = 
  ,parms  =
  ,report =
);

%local dsid;

ods _all_ close;
ods rtf file="&report"; 

/*-- Compute regression analysis ---------------------------------------------*/
proc reg data=&data outest=&parms; 
   model &y = &x; 
   output out=&out(keep=&x &y &yhat) p=&yhat; 
   plot &y * &x; 
run; quit; 

ods rtf close; 

%MEND regression;

/** \endcond */
