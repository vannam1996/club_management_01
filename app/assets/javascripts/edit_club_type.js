$(document).ready(function() {
  $('#save-club-type').on('click', function(){
    var name = $('#name').val();
    var id = $('#save-club-type').val();
    var organization_slug = $('#organization_slug').val();
    var data = {name: name, organization_id: organization_slug};
    $.ajax(
    {
      url: '/organizations/'+organization_slug+'/club_types/'+id,
      type: 'PATCH',
      data: data,
    });
  });
});
