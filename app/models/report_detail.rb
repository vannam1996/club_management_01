class ReportDetail < ApplicationRecord
  belongs_to :statistic_report, required: true
  belongs_to :report_category, required: true

  enum type: {pay_money: 1, get_money: 2, orther: 3}
  delegate :name, to: :report_category, prefix: :report_category, allow_nil: :true
end
