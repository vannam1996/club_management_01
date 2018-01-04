$(document).ready(function () {
  $('#checkall').change(function(){
    $('.checkbox').prop('checked', $(this).prop('checked'));
  });
});

