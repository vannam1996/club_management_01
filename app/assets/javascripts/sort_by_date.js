$('.sort-bubget').dataTable( {
  destroy: true,
  columnDefs: [
    { type: 'date-dd-mmm-yyyy', targets: 0 }
   ]
});
$('#checkAll').change(function(){
  $('.checkbox').prop('checked', $(this).prop('checked'))
});
