class RuleDetail < ApplicationRecord
  acts_as_paranoid

  belongs_to :rule
  has_many :evaluate_details, dependent: :destroy

  validates :content, presence: true
  validates :points, presence: true
end
