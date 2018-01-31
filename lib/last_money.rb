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
      expense = event.expense.to_i
      case
      when event.get_money?
        expense * event.budgets.size
      when event.pay_money?
        - expense
      when event.subsidy?
        expense
      end
    end

    def last_money_detail detail
      if detail.pay_money?
        detail.first_money - detail.money
      elsif detail.get_money?
        detail.first_money + detail.money
      else
        Settings.default_value_return
      end
    end
  end
end
