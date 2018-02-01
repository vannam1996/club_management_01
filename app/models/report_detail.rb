class ReportDetail < ApplicationRecord
  belongs_to :statistic_report, required: true
  belongs_to :report_category, required: true

  enum style: {pay_money: 1, get_money: 2, other: 3}

  scope :load_detail_budgets, ->{where.not style: :other}
  scope :load_date_report, ->{where.not date_event: nil}

  delegate :name, to: :report_category, prefix: :report_category, allow_nil: :true
end
