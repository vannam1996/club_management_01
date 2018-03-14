class CriteriaDetail < ApplicationRecorddetails
  belongs_to :criteria
  has_many :evaluates, dependent: :destroy
end
