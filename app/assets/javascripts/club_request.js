$(document).ready(function() {
  $('.select_custom').on('change', function() {
    user_id = $('#user_id').val()
    var dataform = {
      organization_id: $('.select_custom').val()
    }
    $.ajax('/users/'+user_id+'/club_requests/new',
    {
      type: 'GET',
      data: dataform,
      success: function(result) {
        $('#user_club_request').html(result);
      },
      error: function (result) {
        alert(I18n.t('error_load_user_organization'));
      }
    });
  });
});
