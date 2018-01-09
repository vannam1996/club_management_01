$(document).ready(function() {
  $('#style_reports').on('change', function() {
    SearchReport();
    if ($('#style_reports').val() === '1' || $('#style_reports').val() === '')
    {
      $('.month-select').show();
      $('.quarter-select').hide();
    }
    else if ($('#style_reports').val() === '2')
    {
      $('.month-select').hide();
      $('.quarter-select').show();
    }
  });
  $('#month_reports').on('change', function() {
    SearchReport();
  });
  $('#quarter_report').on('change', function() {
    SearchReport();
  });
  $('#year_report').on('change', function() {
    SearchReport();
  });
});
function SearchReport() {
  var style_reports = $('#style_reports').val();
  var organization_id = $('#organization_id').val();
  if (style_reports == 2){
    time = $('#quarter_report').val();
  }
  else {
    time = $('#month_reports').val();
  }
  var year = $('#year_report').val();
  var data = {q: {style_eq: style_reports, time_eq: time, year_eq: year}}
  $.get('/statistic_reports/?organization_slug=' + organization_id, data , null, 'script');
  return false;
}
