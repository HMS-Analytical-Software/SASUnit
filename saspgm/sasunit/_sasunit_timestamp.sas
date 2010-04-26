/** \file
   \ingroup    SASUNIT_UTIL

   \brief      gibt formatierten Timestamp-String aus einem angegebenen datetime-Wert zurück 
               oder aus dem aktuellen datetime-Wert.

               Folgender Aufruf gibt einen Timestamp in den Log aus: 
               \%PUT \%timestamp; 
               Folgender Aufruf gibt den 1.1.2000, 0 Uhr in den Log aus: 
               \%PUT \%timestamp('01JAN2000:00:00:00'dt); 

   \param      dt Positionsparameter, datetime-Wert der formatiert werden soll. Wenn leer wird 
                  die aktuelle Systemzeit genommen
   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \return  Timestamp in der Form yyyy-mm-dd-hh-ss.sss
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
