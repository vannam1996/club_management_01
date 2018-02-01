$(document).ready(function () {
  $('#event_event_category').change(function(){
    var cat = $('#event_event_category').val();
    if (cat === gon.event_categories.donate.toString()){
      $('.expense').hide();
      $('.expense_details').hide();
      $('.get-money-member').hide();
      $('#event_expense').prop('disabled', false);
    }
    else if (cat === gon.event_categories.pay_money.toString() || cat === gon.event_categories.receive_money.toString()) {
      $('.expense').show();
      $('#label-expense').text($('#subsidy').text());
      $('.expense_details').show();
      $('.get-money-member').hide();
      $('#event_expense').prop('disabled', true);
    }
    else if (cat === gon.event_categories.get_money.toString()) {
      $('#label-expense').text($('#get_money_member').text());
      $('.expense').show();
      $('.expense_details').hide();
      $('#event_expense').prop('disabled', false);
    }
    else if (cat === gon.event_categories.subsidy.toString()) {
      $('#label-expense').text($('#subsidy').text());
      $('.expense').show();
      $('.expense_details').hide();
      $('#event_expense').prop('disabled', false);
    }
  });
});
