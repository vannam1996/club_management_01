$(document).on('change', 'input#background-org', function(event){
  $('#image-background-org').cropper('destroy');
  var input = this;
  var target = $(event.currentTarget);
  var file = target[0].files[0];
  var reader = new FileReader();
  var acceptFileTypes = /^image\/(jpg|png|jpeg|gif)$/i;
  var img_tag = target.parent().find('#preview_avatar').children('img');
  if(file['type'].length && !acceptFileTypes.test(file['type'])) {
      alert(I18n.t('js.file_type'));
      input.value = '';
      return false;
    }
  else{
    reader.onload = function(e){
      var img = new Image();
      img.src = e.target.result;
      $('#image-background-org').attr('src', img.src);
      $('.cropper-canvas img, .cropper-view-box img').attr('src', img.src);
      cropImage();
    };
    reader.readAsDataURL(file);
  }
});

function cropImage(){
  var $crop_x = $('input#org_bgr_crop_x'),
    $crop_y = $('input#org_bgr_crop_y'),
    $crop_w = $('input#org_bgr_crop_w'),
    $crop_h = $('input#org_bgr_crop_h');
  $('#image-background-org').cropper({
    viewMode: 1,
    aspectRatio: 1,
    background: false,
    zoomable: false,
    getData: true,
    aspectRatio: 3.2,
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
