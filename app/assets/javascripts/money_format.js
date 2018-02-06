$(document).ready(function () {
  $('.expense_details').on('keyup', '.money-input', function(event){
    $(this).val($(this).val().replace(/[^0-9\,]/g,''));
    $(this).val(format($(this).val()));
    setMoney();
  });

  $('.money-input').each(function(index){
    $(this).val(format($(this).val()));
    setMoney();
  });

  $('#add_field_detail a.add_fields').data('association-insertion-method', 'after');
  $('#add_field_detail a.add_fields').data('association-insertion-traversal', 'closest');

  $('#expense_details')
  .on('cocoon:after-insert', function(){
  })
  .on('cocoon:after-remove', function() {
    setMoney();
  });

  $('#event_expense').on('keyup', function(){
    $(this).val($(this).val().replace(/[^0-9\,]/g,''));
    $(this).val(format($(this).val()));
  });
  $('#event_expense').val(format($('#event_expense').val()));
});

var format = function(num){
  var str = num.toString().replace('$', ''), parts = false, output = [], i = 1, formatted = null;
  if(str.indexOf('.') > 0) {
    parts = str.split('.');
    str = parts[0];
  }
  str = str.split('').reverse();
  for(var j = 0, len = str.length; j < len; j++) {
    if(str[j] != ',') {
      output.push(str[j]);
      if(i%3 == 0 && j < (len - 1)) {
          output.push(',');
      }
      i++;
    }
  }
  formatted = output.reverse().join('');
  return(formatted + ((parts) ? '.' + parts[1].substr(0, 2) : ''));
};

function setMoney(){
  var count = 0;
  $.each($('.money-input:visible'), function(index, value){
    count += parseInt($(value).val().replace(/,/g, ''));
  });
  $('#event_expense').val(format(count));
}
