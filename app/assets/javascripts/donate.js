$(document).ready(function() {
  $('.search').keyup(function () {
    var name = $(this).val();
    var club_id = $('#id_club').val();
    var event_id = $('#id_event').val();
    var data = {user: name}
    if(name.length > 1){
      $.get('/clubs/' + club_id + '/events/' + event_id + '/set_user_donates', data , null, 'script');
    }
  });
});
$(document).ready(function() {
  $(document).on('click', '.list-user-donate',function(){
    var id = $(this).attr('data-id');
    var club_id = $('#id_club').val();
    var event_id = $('#id_event').val();
    $.get('/clubs/' + club_id + '/events/' + event_id + '/set_user_donates/' + id, null , null, 'script');
  });
  $(document).on('click', '.submit-form',function(){
    var club_id = $('#id_club').val();
    var event_id = $('#id_event').val();
    var email = $('.user-email').val();
    var expense = $('.user-expense').val();
    var name = $('.user-name').val();
    var data = {name: name, email: email, expense: expense}
    $.post('/clubs/' + club_id + '/events/' + event_id + '/set_user_donates/', data , null, 'script');
  });
});
