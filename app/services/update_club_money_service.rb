class UpdateClubMoneyService
  def initialize event, club, event_params
    @event = event
    @club = club
    @event_params = event_params
  end

  def update_event
    @event.update_attributes! @event_params
  end

  def plus_money_club
    @club.update_attributes! money: @club.money + @event_params[:expense].to_i
  end

  def money_change_when_update_event
    @club.update_attributes! money: @club.money.to_i - @event.expense.to_i + @event_params[:expense].to_i
  end

  def save_event_and_plus_money_club_in_activity_event
    @event.save!
    plus_money_club if @event.activity_money?
  end

  def update_event_and_money_club_in_activity_event
    money_change_when_update_event if @event.activity_money?
    @event.update_attributes! @event_params
  end

  def save_event_and_plus_money_club_in_money_event
    @event.save!
    plus_money_club if is_money_type_event?
  end

  def update_event_and_money_club_in_money_event
    case @event_params[:event_category]
    when Event.event_categories[:money], Event.event_categories[:subsidy],
      Event.event_categories[:donate]
      money_change_when_update_event
    when Event.event_categories[:get_money_member]
      update_money
    end
    @event.update_attributes! @event_params
  end

  private

  def is_money_type_event?
    Event.event_categories.except(:notification, :activity_money, :get_money_member)
      .keys.include? @event.event_category
  end

  def update_money
    if @event.get_money_member?
      @event.club.update_attributes! money: @event.club.money - (@event.budgets.size * @event.expense.to_i)
    end
  end
end
