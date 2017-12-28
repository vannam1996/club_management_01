$(document).ready(function() {
  $('.btn_choose_member').on('click', function(){
    var users = [];
    $.each($("input[name='user_club_request[user_ids][]']:checked"), function(){
      users.push($(this).closest('td').next().text().trim());
    });
    text = users.join(', ');
    label = $('#members-label').text();
    $('#members').text(label + text);
  });
});
