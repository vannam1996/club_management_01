class EvaluateDetail < ApplicationRecord
  belongs_to :evaluate
  belongs_to :rule_detail
end
