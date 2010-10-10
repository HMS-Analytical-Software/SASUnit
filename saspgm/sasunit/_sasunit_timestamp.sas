/** \file
   \ingroup    SASUNIT_UTIL

   \brief      return a formatted timestamp string from a specified datetime value
               or from the current time.

               For instance, to show the current time in the SAS log:: 
               \%PUT \%timestamp; 
               The following call writes a specific datetime to the SAS log: 
               \%PUT \%timestamp('01JAN2000:00:00:00'dt); 

   \param      dt input datetime value or empty to use the current date and time. 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \return  timestamp in the form yyyy-mm-dd-hh-ss.sss
*/ /** \cond */ 

%MACRO _sasunit_timestamp(dt);
%LOCAL dt d t;
%IF &dt= %THEN %LET dt=%sysfunc(datetime());
%LET d=%sysfunc(datepart(&dt));
%LET t=%sysfunc(timepart(&dt));
%LET h=%sysfunc(hour(&t));
%LET m=%sysfunc(minute(&t));
%LET s=%sysfunc(second(&t));
%sysfunc(putn(&d,yymmdd10.))-%sysfunc(putn(&h,z2.))-%sysfunc(putn(&m,z2.))-%sysfunc(putn(&s,z6.3))
%MEND _sasunit_timestamp;
/** \endcond */
