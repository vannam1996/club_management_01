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
      when event.subsidy? || event.donate?
        expense
      end
    end
  end
end
