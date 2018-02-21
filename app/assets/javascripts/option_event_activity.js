$(document).ready(function () {
  $('#event_event_category').change(function(){
    var cat = $('#event_event_category').val();
    if (cat === gon.notification.toString()){
      $('#expense').hide();
      $('.expense_details').hide();
    }
    else if (cat === gon.activity_money.toString()) {
      $('.expense_details').show();
    }
  });

  $('.button-add-detail').on('click', function(){
    if ($('#expense').is(':hidden')){
      $('#expense').show() ;
    }
  });
});
