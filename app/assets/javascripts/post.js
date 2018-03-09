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

  $('#fields_image').on('click', '.image_view', function(){
    $(this).parents('.list-gallery').find('.img-file-input').click();
  });

  $('#fields_image').on('change', '.img-file-input', function(){
    self = $(this).parents('.list-gallery').find('.image_view');
    $(this).parents('.list-gallery').find('.btn-remove').show();
    var check = false;
    $('.image_view').each(function(){
      if ($(this).attr('src').split('/')[1].toString() === 'assets' && this != self[0]){
        check = true;
      }
    });
    if (check === false){
      $('.button-add-gallery').click();
      $('#image-list-preview .list-gallery:nth-last-child(2)').find('.btn-remove').hide();
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

  $('#video-list-url').on('change', '.url-input', function(){
    $(this).parents('.list-video').find('.bt-del-field').show();
    var check = false;
    $('.url-input').each(function(){
      if ($(this).val() === ''){
        check = true;
      }
    });
    if (check === false){
      $('.button-add-video').click();
      $('#video-list-url .list-video:nth-last-child(2)').find('.bt-del-field').hide();
    }
  });
});
