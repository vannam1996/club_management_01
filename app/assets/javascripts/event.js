$(document).ready(function () {
  $('#event_event_category').change(function(){
    var cat = $('#event_event_category').val();
    if (cat === gon.event_money.donate.toString()){
      $('#expense').show();
      $('.expense_details').hide();
      $('#event_expense').prop('disabled', false);
      $('#label-expense').text($('#subsidy').text());
    }
    else if (cat === gon.event_money.money.toString()) {
      $('#expense').show();
      $('#label-expense').text($('#subsidy').text());
      $('.expense_details').show();
      $('.get-money-member').hide();
      $('#event_expense').prop('disabled', true);
    }
    else if (cat === gon.event_money.get_money_member.toString()) {
      $('#label-expense').text($('#get_money_member').text());
      $('#expense').show();
      $('.expense_details').hide();
      $('#event_expense').prop('disabled', false);
    }
    else if (cat === gon.event_money.subsidy.toString()) {
      $('#label-expense').text($('#subsidy').text());
      $('#expense').show();
      $('.expense_details').hide();
      $('#event_expense').prop('disabled', false);
    }
  });
});
