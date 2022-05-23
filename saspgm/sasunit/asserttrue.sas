/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether a condition is true (provided by Chuck Castillo).
   
               For NUMERIC types a 0 evaluates to false, all other numbers evaluate to true
               
               For CHAR types an empty string or a string containing all blanks evaluates to false.
               The word false (case insensitive) also evaluates to false.
               All other character sequences evaluate to true.

   \author     \$Author$

   \param   i_cond        	the condition to evaluate
   \param   i_desc         description of the assertion to be checked

*/ /** \cond */ 
%MACRO assertTrue (
    i_cond =         
   ,i_desc =      
);

%GLOBAL g_inTestCase;
%endTestCall(i_messageStyle=NOTE);
%IF %_checkCallingSequence(i_callerType=assert) NE 0 %THEN %DO;      
   %RETURN;
%END;

%LOCAL l_result l_expected l_actual;

/*-- evaluate character type  ------------------------------------------------*/
%IF (%datatyp(&i_cond.) eq CHAR) %THEN %DO;
   %LET l_expected=true;
	%IF (%length(&i_cond.) eq 0) %THEN %DO;
		%LET l_result = 2;
	%END;
	%ELSE %DO;
      %LET l_actual = %lowcase (&i_cond.); 
      %IF (&l_actual. eq true) %THEN %DO;
         %LET l_result = 0;
      %END;
      %ELSE %IF (&l_actual. eq false) %THEN %DO;
         %LET l_result = 2;
      %END;
      %ELSE %DO;
         %LET l_actual = %sysfunc(strip(&i_cond.));         
         %LET l_result = %eval((%length(&l_actual.) eq 0)*2);
      %END;
   %END;
%END;
/*-- evaluate numeric type  ------------------------------------------------*/
%ELSE %IF (%datatyp(&i_cond.) eq NUMERIC) %THEN %DO;
   %LET l_expected=1;
   %LET l_actual = &i_cond.;
	%IF (&i_cond eq 0) %THEN %DO;
		%let l_result = 2;
	%END;
	%ELSE %DO;
		%let l_result = 0;
	%END;   
%END;

%_asserts(
    i_type     = assertTrue
   ,i_expected = &l_expected.
   ,i_actual   = &l_actual.
   ,i_desc     = &i_desc.
   ,i_result   = &l_result.
)
%MEND;
/** \endcond */