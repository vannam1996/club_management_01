$(document).ready(function() {
  $('.input-search').keyup(function () {
    var searchTerm = $('.input-search').val();
    var listItem = $('.results tbody').children('tr');
    var searchSplit = searchTerm.replace(/ /g, "'):containsi('")

    $.extend($.expr[':'], {'containsi': function(elem, i, match, array){
      return (elem.textContent || elem.innerText || '').toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0;
      }
    });

    $('.results tbody tr').not(':containsi("' + searchSplit + '")').each(function(e){
      $(this).attr('visible','false');
    });

    $('.results tbody tr:containsi("' + searchSplit + '")').each(function(e){
      $(this).attr('visible','true');
    });
  });
});

$(document).ready(function() {
  $('.input-search-edit').keyup(function () {
    var searchTerm = $('.input-search-edit').val();
    var listItem = $('.result tbody').children('tr');
    var searchSplit = searchTerm.replace(/ /g, "'):containsi('")

    $.extend($.expr[':'], {'containsi': function(elem, i, match, array){
      return (elem.textContent || elem.innerText || '').toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0;
      }
    });

    $('.result tbody tr').not(':containsi("' + searchSplit + '")').each(function(e){
      $(this).attr('visible','false');
    });

    $('.result tbody tr:containsi("' + searchSplit + '")').each(function(e){
      $(this).attr('visible','true');
    });
  });
});
