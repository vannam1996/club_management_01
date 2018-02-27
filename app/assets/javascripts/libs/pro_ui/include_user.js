// $(document).on('turbolinks:load', function() {
jQuery(document).ready(function($) {

  $('.form-search-clubs').on('keyup', function(e) {
    SearchClub();
  });

  $('.stype-clubs').on('change', function(e) {
    SearchClub();
  });

  $('.range-slider-demo').on('change', function(e) {
    SearchClub();
  });

  $('.stype-organizations').on('change', function(e) {
    SearchClub();
  });

  $('.sort-clubs').on('change',function(e) {
    SearchClub();
  });

  $('input.rating[type=number]').rating();

  $(document).on('change', '#file-upload', function(e) {
    var preview = document.getElementById("img-upload");
    var file    = document.querySelector('input[type=file]').files[0];
    var reader  = new FileReader();
    reader.onloadend = function () {
      preview.src = reader.result;
    }
    if (file) {
      reader.readAsDataURL(file);
    } else {
      preview.src = "";
    }
  });

  $('.load-more-message').click(function(){
    if($(this).scrollTop() == 0){
      $.ajax({
        type: 'GET',
        url: '/messages',
        data: {num_message: $('.num-step-message').val(), id: $('#chat-box-club-id').val()}
      });
    }
  });

  $("#ecom-filter-rating").change(function(){
    $("#ecom-search").attr("name", "q[rating_eq]");
    $("#ecom-search").val($(this).val());
    $("#club_search").submit();
  });

  $("#example-datatable").dataTable();

  $('a[data-toggle="collapse"]').click(function () {
    $(this).find('span.toggle-icon').toggleClass('fa fa-envelope-open-o fa fa-envelope-o');
  });

  $("#ecom-filter-rating").change(function(){
    $("#ecom-search").attr("name", "q[rating_eq]");
    $("#ecom-search").val($(this).val());
    $("#club_search").submit();
    $("#example-datatable").dataTable();
  });

  $("#ecom-filter-condition").change(function(){
    $("#ecom-search").attr("name", "q[club_type_eq]");
    $("#ecom-search").val($(this).val());
    document.getElementById("search-club-input").style.display = 'none';
    $("#club_search").submit();
    $("#example-datatable").dataTable();
  });

  $("#ecom-filter-organization").change(function(){
    $("#ecom-search").attr("name", "q[organization_id_eq]");
    $("#ecom-search").val($(this).val());
    document.getElementById("search-club-input").style.display = 'none';
    $("#club_search").submit();
    $("#example-datatable").dataTable();
  });

  $(".join-event").click(function(){
    $("#new_user_event").submit();
  });

  $("#request-type").click(function() {
    if ($(this).val() == "Organization"){
      $.get(
        "/users/1/organization_requests", {
          type: $(this).val()
        },
        function(data) {}
      );
    }else{
      $.get(
        "/users/1/club_requests", {
          type: $(this).val()
        },
        function(data) {}
      );
    }
  });

  $('#budget-filter').change(function(){
    var limit_page = $('#limit_page').val();
    var first_date = $('#date_first').val();
    var second_date = $('#date_end').val();
    var club_id = $('#club_id').val();
    if (first_date === "" && second_date === ""){
      data = {page: 1, limit_page: limit_page};
      $.get('/clubs/' + club_id + '/budgets', data , null, 'script');
    }
    else if (first_date != "" && second_date != "")
    {
      var data = {date_search: {first_date: first_date,
        second_date: second_date}, limit_page: limit_page}
      $.get('/clubs/' + club_id + '/budgets', data , null, 'script');
    }
    else if (first_date === "" || second_date === "")
    {
      data = {page: 1, limit_page: limit_page};
      $.get('/clubs/' + club_id + '/budgets', data , null, 'script');
    }
    return false;
  });

  $('.org-link-to').click(function(){
    window.open($(this).attr('data-link'), '_self');
  });
  App.init();
});

$(document).ready(function() {
  TablesDatatables.init();
});

function SearchClub() {
  var sort_club = $('.sort-clubs').val();
  var sort_params = LoadSortParam(sort_club);
  var search = $('.form-search-clubs').val();
  var stype_clubs = $('.stype-clubs').val();
  var rate_value = $( ".range-slider-demo" ).val();
  var rate = rate_value.split(",");
  var rate_gteq = rate[0];
  var rate_lteq = rate[1];
  var stype_organizations = $('.stype-organizations').val();
  var data = {q: {s: [sort_params, sort_club], name_or_content_cont: search,
    club_type_id_eq: stype_clubs, organization_id_eq: stype_organizations,
    rating_gteq: rate_gteq, rating_lteq: rate_lteq}}
  $.get('/my_clubs', data , null, 'script');
  return false;
}
