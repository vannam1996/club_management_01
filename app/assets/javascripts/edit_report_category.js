$(document).ready(function() {
  $('#save-report-category').on('click', function(){
    var name = $('#name').val();
    var id = $('#save-report-category').val();
    var organization_slug = $('#organization_slug').val();
    var status = $('#status_report_category').val();
    var data = {name: name, status: status, organization_slug: organization_slug};
    $.ajax(
    {
      url: '/report_categories/'+id,
      type: 'PATCH',
      data: data,
    });
  });
});
