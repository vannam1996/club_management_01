class EvaluateDetail < ApplicationRecord
  acts_as_paranoid

  belongs_to :evaluate
  belongs_to :criteria_detail
end
