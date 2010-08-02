/** \file
   \ingroup    SASUNIT_UTIL 

   \brief     get file extension including the separating dot

   \%getExtension(file name)

              Example: %getExtension(test.sas) yields .sas

   \param   i_file     file name with extension
   \return  file name extension or empty if file name does not contain a dot

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
*/ /** \cond */ 

%MACRO _sasunit_getExtension (
    i_file  
); 

%LOCAL i; %LET i=0;
%DO %WHILE("%scan(&i_file,%eval(&i+1),.)" NE "");
   %LET i=%eval(&i+1);
%END;
%IF &i>1 %THEN .%scan(&i_file,&i,.);

%MEND _sasunit_getExtension;
/** \endcond */
