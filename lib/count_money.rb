class CountMoney
  def initialize params
    @params = params
  end

  def money
    count = Settings.default_money
    if @params
      @params.each do |key, value|
        count += value[:money].to_i if value[:money]
      end
    end
    count
  end
end
