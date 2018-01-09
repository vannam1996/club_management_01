$(document).ready(function() {
  $('#style_report').on('change', function() {
    SearchReport();
    if ($('#style_report').val() === gon.month.toString()
      || $('#style_report').val() === '')
    {
      $('.month-select').show();
      $('.quarter-select').hide();
    }
    else if ($('#style_report').val() === gon.quarter.toString())
    {
      $('.month-select').hide();
      $('.quarter-select').show();
    }
  });
  $('#month-time').on('change', function() {
    SearchReport();
  });
  $('#quarter-time').on('change', function() {
    SearchReport();
  });
  $('#year_report').on('change', function() {
    SearchReport();
  });
  $('#status').on('change', function(){
    SearchReport();
  });
});
function SearchReport() {
  var club_slug = $('#club-slug').val();
  var style_report = $('#style_report').val();
  var year = $('#year_report').val();
  var status = $('#status').val();
  var time = ''
  if (style_report === gon.quarter.toString()){
    time = $('#quarter-time').val();
  }
  else {
    time = $('#month-time').val();
  }
  var data = {q: {style_eq: style_report, time_eq: time, year_eq: year, status_eq: status}}
  $.get('/club_manager/clubs/'+club_slug+'/statistic_reports/', data , null, 'script');
  return false;
}
