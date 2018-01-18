class ReportDetail < ApplicationRecord
  belongs_to :statistic_report, required: true
  belongs_to :report_category, required: true

  delegate :name, to: :report_category, prefix: :report_category, allow_nil: :true
end
