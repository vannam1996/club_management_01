$(document).ready(function() {
  $('#style_report').on('change', function() {
    SearchReport();
  });
  $('#time').on('change', function() {
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
  var time = $('#time').val();
  var year = $('#year_report').val();
  var status = $('#status').val();
  var data = {q: {style_eq: style_report, time_eq: time, year_eq: year, status_eq: status}}
  $.get('/club_manager/clubs/'+club_slug+'/statistic_reports/', data , null, 'script');
  return false;
}
