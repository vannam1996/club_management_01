$(document).ready(function() {
  $('#save-report-category').on('click', function(){
    var name = $('#name').val();
    var id = $('#save-report-category').val();
    var organization_slug = $('#organization_slug').val();
    var status = $('#status_report_category').is(':checked');
    var active = $('#active_report_category').is(':checked');
    var data = {name: name, status: Number(status), status_active: Number(active), organization_slug: organization_slug};
    $.ajax(
    {
      url: '/report_categories/' + id,
      type: 'PATCH',
      data: data,
    });
  });
});
