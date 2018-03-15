class CriteriaDetail < ApplicationRecord
  acts_as_paranoid

  belongs_to :criteria
  has_many :evaluates, dependent: :destroy
end
