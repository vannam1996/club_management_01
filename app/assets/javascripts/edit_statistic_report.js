$(document).ready(function() {
  $('#style-report').change(function() {
    if ($('#style-report').val() === gon.month.toString())
    {
      $('.month-style').show();
      $('.quarter-style').hide();
    }
    else if ($('#style-report').val() === gon.quarter.toString())
    {
      $('.month-style').hide();
      $('.quarter-style').show();
    }
  });
});
