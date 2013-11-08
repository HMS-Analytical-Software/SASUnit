%macro _opendummyhtmlpage;
   ods html file="%sysfunc(pathname(work))/dummyhtml.html" style=styles.SASUnit stylesheet=(URL="SAS_SASUnit.css");
%mend;
