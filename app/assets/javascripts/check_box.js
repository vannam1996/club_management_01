$(document).ready(function () {
  $('body').on('click', '.cb-value', function() {
    var mainParent = $(this).parent('.toggle-btn');
    if($(mainParent).find('input.cb-value').is(':checked')) {
      $(mainParent).addClass('active');
    } else {
      $(mainParent).removeClass('active');
    }
  });
});
