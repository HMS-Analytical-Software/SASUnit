$(document).ready(function() {
   $("table").tablesorter({
   
   // use save sort widget
   widgets: ["saveSort"]
   });
   
   $('button').click(function(){
      $('table')
         .trigger('saveSortReset') // clear saved sort
         .trigger("sortReset");    // reset current table sort
      return false;
   });
});