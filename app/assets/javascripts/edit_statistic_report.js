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

  $('#detail a.add_fields').data('association-insertion-method', 'append');
  var item_selected = [];

  $('#detail-report-field')
  .on('cocoon:before-insert', function(e, insertedItem) {
    item_selected = []
    $('.select_category_report_edit').each(function () {
      item_selected.push($(this).val());
    });
  })
  .on('cocoon:after-insert', function(e, insertedItem) {
    id_select = insertedItem.find('.select_category_report_edit').attr('id');
    $.each(item_selected, function (index, value) {
      $('#' + id_select + ' option[value=' + value + ']').remove();
    });
    if ($('#' + id_select + ' option').size() === 1) {
      $('#button-add-fields').hide();
    }
  })
  .on('cocoon:after-remove', function() {
    $('#button-add-fields').show();
  });
});
