$(document).on('change', 'input#club_logo', function(event){
  $('#logo-club-crop').cropper('destroy');
  var input = $(event.currentTarget);
  var file = input[0].files[0];
  var reader = new FileReader();
  var img_tag = input.parent().find('#preview_avatar').children('img');
  reader.onload = function(e){
    var img = new Image();
    img.src = e.target.result;
    $('#logo-club-crop').attr('src', img.src);
    $('.cropper-canvas img, .cropper-view-box img').attr('src', img.src);
    cropImage();
  };
  reader.readAsDataURL(file);
});

function cropImage(){
  var $crop_x = $('input#club_logo_crop_x'),
    $crop_y = $('input#club_logo_crop_y'),
    $crop_w = $('input#club_logo_crop_w'),
    $crop_h = $('input#club_logo_crop_h');
  $('#logo-club-crop').cropper({
    viewMode: 1,
    aspectRatio: 1,
    background: false,
    zoomable: false,
    getData: true,
    aspectRatio: 1.5,
    built: function () {
      var croppedCanvas = $(this).cropper('getCroppedCanvas', {
        width: 100,
        height: 100
      });
      croppedCanvas.toDataURL();
    },
    crop: function(data) {
      $crop_x.val(Math.round(data.x));
      $crop_y.val(Math.round(data.y));
      $crop_h.val(Math.round(data.height));
      $crop_w.val(Math.round(data.width));
    }
  });
}
