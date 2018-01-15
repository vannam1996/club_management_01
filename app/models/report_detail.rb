class ReportDetail < ApplicationRecord
  belongs_to :statistic_report, required: true
  belongs_to :report_category, required: true
end
