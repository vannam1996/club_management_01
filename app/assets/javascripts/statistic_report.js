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

  $('#detail a.add_fields').data('association-insertion-method', 'append');
  var item_selected = [];

  $('#detail-report-field')
  .on('cocoon:before-insert', function(e, insertedItem) {
    item_selected = []
    $('.select_category_report_index').each(function () {
      item_selected.push($(this).val());
    });
  })
  .on('cocoon:after-insert', function(e, insertedItem) {
    id_select = insertedItem.find('.select_category_report_index').attr('id');
    $.each(item_selected, function (index, value) {
      $('#'+id_select+' option[value='+value+']').remove();
    });
    if($('#'+id_select + ' option').size() === 1){
      $('#button-add-fields').hide();
    }
  })
  .on("cocoon:after-remove", function() {
    $('#button-add-fields').show();
  });
});
