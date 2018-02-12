$(document).ready(function () {
  $('#event_event_category').change(function(){
    var cat = $('#event_event_category').val();
    if (cat === gon.notification.toString()){
      $('#collapse-money').hide();
    }
    else if (cat === gon.activity_money.toString()) {
      $('#collapse-money').show();
    }
  });

  $("#money-details").on("hide.bs.collapse", function(){
    $('#money-details').removeClass('form-money');
    $('#icon-open').removeClass('fa-caret-square-o-up').addClass('fa-caret-square-o-down');
  });

  $("#money-details").on("show.bs.collapse", function(){
    $('#money-details').addClass('form-money');
    $('#icon-open').removeClass('fa-caret-square-o-down').addClass('fa-caret-square-o-up');
  });
});
