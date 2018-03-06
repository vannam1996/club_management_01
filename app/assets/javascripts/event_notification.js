$(document).ready(function () {
  $(document).ready(function () {
    $('.show-more').click(function(e){
      e.preventDefault();
      id_event = $(this).attr('data-event');
      $('#description-' + id_event).hide();
      $('#content-' + id_event).show();
    });
  });
});
