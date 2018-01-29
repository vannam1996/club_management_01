class LastMoney
  def initialize events
    @events = events
  end

  def surplus surplus
    @events.each do |event|
      surplus += LastMoney.last_money event
    end
    surplus
  end

  class << self
    def last_money event
      case
      when event.get_money?
        event.expense * event.budgets.size
      when event.pay_money?
        - event.expense
      when event.subsidy?
        event.expense
      end
    end
  end
end
