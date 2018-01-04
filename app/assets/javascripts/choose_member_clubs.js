$(document).ready(function() {
  console.log("aaa");
  $('.btn_choose_member').on('click', function(){
    var users = [];
    $.each($("input[name='user_club[user_ids][]']:checked"), function(){
      users.push($(this).closest('td').next().text().trim());
    });
    text = users.join(', ');
    label = $('#members-label').text();
    $('#members').text(label + text);
  });
});
