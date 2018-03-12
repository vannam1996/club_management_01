$(document).ready(function() {
  $('.delete_experience').click(function(e){
    e.preventDefault();
    var id = $(this).attr('data-id');
    $('#delete_experience_' + id).remove();
  });
});
