$(document).ready(function () {
  $('#event_event_category').change(function(){
    var cat = $('#event_event_category').val();
    if (cat==3 || cat == 4){
      $('.expense').hide();
    }else{
      $('.expense').show();
    }
  });
});
