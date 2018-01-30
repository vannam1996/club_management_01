$(document).ready(function () {
  var files = [];
  $('#new_video').on('submit', function(e) {
    e.preventDefault();
    if (files.length < 1) return;
    $.each(files, function(index, file) {
      file.submit();
    });
    files = [];
  });
  var album_id = $('#video_album_id').val();
  var club_slug = $('#video_club_id').val();
  $('#new_video').fileupload({
    dataType: 'json',
    method: 'post',
    url: '/clubs/' + club_slug + '/albums/' + album_id + '/videos/upload',
    maxChunkSize: 1000000,
    add: function(e, data) {
      var uploadErrors = [];
      var acceptFileTypes = /^video\/(mp3|mp4|3gp)$/i;
      if(data.originalFiles[0]['type'].length && !acceptFileTypes.test(data.originalFiles[0]['type'])) {
        uploadErrors.push('Not an accepted file type');
      }
      if(data.originalFiles[0].size > 500000000) {
        uploadErrors.push('Filesize is too big');
      }
      if(uploadErrors.length > 0) {
          alert(uploadErrors.join('\n'));
      }
      else {
        $.each(data.files, function(index, file) {
          $('#name-file').text(file.name);
          $.ajax({
            method: 'post',
            dataType: 'json',
            url: '/clubs/' + club_slug + '/albums/' + album_id + '/videos',
            data: {filename: file.name},
            success: function(res) {
              data.formData = res;
              files = [];
              files.push(data);
            }
          });
        });
      }
    },
    progressall: function(e, data) {
      var done = parseInt(data.loaded * 100) / data.total
      $('#progress .bar').css({ width: done + '%'});
    },
    done: function (e, data) {
      $('#status').text('Uploaded');
      $.ajax({
        method: 'patch',
        dataType: 'json',
        url: '/clubs/' + club_slug + '/albums/' + album_id + '/videos/'+ data.formData.id,
        success: function(res) {
          $('#list-video').html(res.html);
          $('.container').append(res.message);
          $('.notify').delay(4000).slideUp(300);
          $('#modal-new-video').modal('hide');
        }
      });
    },
    start: function (e, data) {
      $('#status').text('Uploading...');
    }
  });
});
