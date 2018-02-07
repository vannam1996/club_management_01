class CountMoney
  def initialize params
    @params = params
  end

  def money
    count = Settings.default_money
    if @params
      @params.each do |key, value|
        if value[:money] && value[:_destroy] != Settings.value_destroy_attribute_params
          if value[:style].to_i == EventDetail.styles[:get]
            count += value[:money].to_i
          elsif value[:style].to_i == EventDetail.styles[:pay]
            count -= value[:money].to_i
          end
        end
      end
    end
    count
  end
end
