$(document).ready(function() {
  $(document).on('change', '#statistic_report_style',function(){
    var club_id = $('#club_id').val();
    var data = {};
    var style = $('#statistic_report_style').val();
    if (style === '1')
    {
      var month = $('#month').val();
      var date_year = $('#date_year').val();
      data = {q: {month: month, date_year: date_year, style: style}}
    }
    else if (style === '2')
    {
      $('.month').hide();
      $('.quarter').show();
      var quarter = $('#quarter').val();
      var date_year = $('#date_year').val();
      data = {q: {quarter: quarter, date_year: date_year, style: style}}
    }
    $.get('/set_static_reports/?club_id=' + club_id, data , null, 'script');
  });

  $('#detail a.add_fields').data('association-insertion-method', 'append');
  var item_selected = [];

  $('#detail-report-field-new')
  .on('cocoon:before-insert', function(e, insertedItem) {
    item_selected = []
    $('.select_category_report_new').each(function () {
      item_selected.push($(this).val());
    });
  })
  .on('cocoon:after-insert', function(e, insertedItem) {
    id_select = insertedItem.find('.select_category_report_new').attr('id');
    if (typeof(id_select) === 'undefined'){
      id_select = insertedItem.find('.select_category_report_index').attr('id');
    }
    $.each(item_selected, function (index, value) {
      $('#' + id_select + ' option[value=' + value + ']').remove();
    });
    if ($('#' + id_select + ' option').size() === 1) {
      $('#button-add-fields-new-form').hide();
    }
  })
  .on('cocoon:after-remove', function() {
    $('#button-add-fields-new-form').show();
  });
  $(document).on('change', '#month',function(){
    var club_id = $('#club_id').val();
    var data = {};
    var style = $('#statistic_report_style').val();
    var month = $('#month').val();
    var date_year = $('#date_year').val();
    data = {q: {month: month, date_year: date_year, style: style}}
    $.get('/set_static_reports/?club_id=' + club_id, data , null, 'script');
  });
  $(document).on('change', '#quarter',function(){
    var club_id = $('#club_id').val();
    var data = {};
    var style = $('#statistic_report_style').val();
    var quarter = $('#quarter').val();
    var date_year = $('#date_year').val();
    data = {q: {quarter: quarter, date_year: date_year, style: style}}
    $.get('/set_static_reports/?club_id=' + club_id, data , null, 'script');
  });
  $(document).on('change', '#date_year',function(){
    var club_id = $('#club_id').val();
    var style = $('#statistic_report_style').val();
    if (style === '1')
    {
      var month = $('#month').val();
      var date_year = $('#date_year').val();
      data = {q: {month: month, date_year: date_year, style: style}}
    }
    else if (style === '2')
    {
      $('.month').hide();
      $('.quarter').show();
      var quarter = $('#quarter').val();
      var date_year = $('#date_year').val();
      data = {q: {quarter: quarter, date_year: date_year, style: style}}
    }
    $.get('/set_static_reports/?club_id=' + club_id, data , null, 'script');
  });
});
