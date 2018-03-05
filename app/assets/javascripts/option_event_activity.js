$(document).ready(function () {
  $('#event_event_details_attributes_0_description').prop('required', false);
  $('#event_event_category').change(function(){
    var cat = $('#event_event_category').val();
    if (cat === gon.notification.toString()){
      $('#collapse-money').hide();
      $('#event_event_details_attributes_0_description').prop('required', false);
    }
    else if (cat === gon.activity_money.toString()) {
      $('#collapse-money').show();
    }
  });

  $("#money-details").on("hide.bs.collapse", function(){
    $('#money-details').removeClass('form-money');
    $('#icon-open').removeClass('fa-caret-square-o-up').addClass('fa-caret-square-o-down');
    $('#event_event_details_attributes_0_description').prop('required', false);
  });

  $("#money-details").on("show.bs.collapse", function(){
    $('#money-details').addClass('form-money');
    $('#icon-open').removeClass('fa-caret-square-o-down').addClass('fa-caret-square-o-up');
    $('#event_event_details_attributes_0_description').prop('required', true);
  });
});
