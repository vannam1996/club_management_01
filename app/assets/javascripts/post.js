$(document).ready(function () {
  $('#fields_image').on('change', '.img-file-input', function(event){
    var input = $(event.currentTarget);
    var file = input[0].files[0];
    var reader = new FileReader();
    input = this;
    reader.onload = function (e) {
      $(input).parents('.nested-fields').find('.image_view').attr('src', e.target.result);
    }
    reader.readAsDataURL(file);
  });

  $('.fields_gallery').on('mouseover', '.image_view', function(){
    $(this).parents('.list-gallery').find('.btn-remove').fadeIn();
  });

  $('.fields_gallery').on('click', '.image_view', function(){
    $(this).parents('.list-gallery').find('.img-file-input').click();
  });

  $('.fields_gallery').on('change', '.img-file-input', function(){
    var check = false;
    $('.img-file-input').each(function(){
      if ($(this).val() === ''){
        check = true;
      }
    });
    if (check === false){
      $('.button-add-gallery').click();
    }
  });

  $('#post-list').on('click', '.show-more',function(e){
    e.preventDefault();
    id_post = $(this).attr('data-post');
    $('#content-truncate-' + id_post).hide();
    $('#content-' + id_post).show();
  });

  $(window).scroll(function(){
    scrollHeight = $(document).height();
    scrollPosition = $(window).height() + $(window).scrollTop();
    url = $('#view-more').find('.next').find('a')
    if ((scrollHeight - scrollPosition) / scrollHeight == 0 && url &&
      $('#post').css('display') === 'block'){
      $(url).click();
    }
  })
});
