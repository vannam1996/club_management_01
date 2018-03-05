CKEDITOR.editorConfig = function( config ) {
  config.skins = 'office2003';
  config.toolbar = 'toolbarLight';
  config.filebrowserImageBrowseUrl = '/ckeditor/pictures';
  config.filebrowserImageUploadUrl = '/ckeditor/pictures';
  config.toolbar_toolbarLight =
  [
    ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Scayt'],
    ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
    ['Image','Table','HorizontalRule','Smiley','SpecialChar', 'Link','Unlink','Anchor', 'Maximize'] ,
    '/',
    ['Styles','Format','Font','FontSize', 'Bold','Italic','Strike','NumberedList','BulletedList','Outdent','Indent','Blockquote', 'TextColor','BGColor'],
  ];
};
