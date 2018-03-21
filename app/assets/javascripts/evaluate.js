$(document).ready(function(){
  $(document).on('change', '.js-cb-point', function(){
    var total = 0;
    id = $(this).val();
    if ($(this).is(':checked') === true){
      $('#js-text-note-' + id).prop('disabled', false)
    }
    else{
      $('#js-text-note-' + id).prop('disabled', true)
    }
    $('.js-cb-point').each(function(){
      if ($(this).is(':checked') === true){
        total += parseFloat($(this).attr('data-point'));
      }
      $('#js-lb-total-point').text(total);
    });
  });
});
