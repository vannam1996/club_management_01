$(document).ready(function() {
  $('#statistic_report_style').change(function() {
    if ($('#statistic_report_style').val() === '1')
    {
      $('.month').show();
      $('.quarter').hide();
    }
    else if ($('#statistic_report_style').val() === '2')
    {
      $('.month').hide();
      $('.quarter').show();
    }
  });
});
