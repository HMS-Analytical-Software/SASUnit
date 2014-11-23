/**
   \file
   \ingroup    SASUNIT_UTIL
   \brief      The macro is called from _dependencyJsonBuilder. It iterates through the dependency tree
               and writes out a .json file to visualize the call hierarchy.
   \version    \$Revision: 282 $
   \author     \$Author: klandwich $
   \date       \$Date: 2013-11-21 11:32:48 +0100 (DO, 21 Nov 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_dependency_wr.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
               
   \param      i_node            Current tree node of this iteration (name of a macro)
   \param      i_dependencies    Data set holding the information for the call hierarchy with columns caller and called
   \param      i_direction       Indicates the direction of the call hierarchy:
                                 0 -> All macros that call a specific macro
                                 1 -> All macros that a specific macro calls
   \param      i_parentList      Used to detect self-referential loops (like A -> B -> A) in every branch of the tree. If 
                                 a loop is detected the macro return to the parent node.
*/ /** \cond */ 

%MACRO _dependency_wr(i_node=
                     ,i_dependencies=
                     ,i_direction=
                     ,i_parentList=
                     );

   %LOCAL l_child l_children l_cntChildren l_i l_node l_direction l_column l_parentList l_len l_this_node l_children_inner;
   %LET l_children =;
   
   /* handle direction */
   %IF &i_direction EQ 1 %THEN %DO;
      %LET l_direction = called;
      %LET l_column = caller;
   %END;
   %ELSE %DO;
      %LET l_direction = caller;
      %LET l_column = called;
   %END;
   
   /* get children of node*/
   PROC SQL noprint;
      select distinct &l_direction 
      into :l_children separated by ' '
      from &i_dependencies 
      where lowcase (&l_column)="%lowcase(&i_node.)"
      ;
   QUIT;

   /* Write data nodes */
   DATA _NULL_;
      FILE json_out mod;
      put '{ "name": "' "&i_node" '"';
   RUN;
   
   %IF "&l_children" NE "" %THEN %DO; 
      /* prepare loop over all children */
      %LET l_cntChildren = %SYSFUNC(countw("&l_children."));
      %DO l_i=1 %TO &l_cntChildren.;
         %LET l_node=%SYSFUNC(SCAN(&l_children,&l_i));
         %LET l_parentList = &i_parentList. &l_node.;

         /* Check for self-referential loops in call hierarchy like A -> B -> A */
         %LET l_len = %SYSFUNC(COUNTW(&l_parentList.));
         %LET l_this_node = %SYSFUNC(SCAN(&l_parentList., &l_len));
         %DO l_j=1 %TO %EVAL(&l_len. - 1);
            %IF "%sysfunc(scan(&i_parentList., &l_j))" EQ "&l_this_node." %THEN %DO;
               /* Return if self referential loop found */
               %RETURN;
            %END; 
         %END;
         
         %IF &l_i EQ 1 %THEN %DO;
            DATA _NULL_;
               FILE json_out mod;
               PUT ', "children": [';
            RUN;
         %END;
         
         /* get children of node*/
         PROC SQL noprint;
            select distinct &l_direction 
            into :l_children_inner separated by ' '
            from &i_dependencies 
            where lowcase (&l_column)="%lowcase(&i_node.)"
            ;
         QUIT;
         
         /* Child node found: recursive call to macro */
         %_dependency_wr(i_node=&l_node., i_dependencies=&i_dependencies., i_parentList=&l_parentList., i_direction=&i_direction.);

         /* Separate children with curly bracket + comma */
         %IF &l_i LT &l_cntChildren. %THEN %DO;
            DATA _NULL_;
               FILE json_out mod;
               PUT '},';
            RUN;
         %END;
         /* Last Child: only curly bracket needed */
         %ELSE %DO;
            DATA _NULL_;
               FILE json_out mod;
               PUT '}';
            RUN;
         %END;

      %END; /* End do i to l_cntChildren */
      /* Add closing bracket after last child */
      DATA _NULL_;
         FILE json_out mod;
         PUT "]";
      RUN;

   %END; /* End if */
%MEND _dependency_wr;
