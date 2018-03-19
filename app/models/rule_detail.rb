class RuleDetail < ApplicationRecord
  acts_as_paranoid

  belongs_to :rule
  has_many :evaluate_details, dependent: :destroy

  validates :content, presence: true
  validates :points, presence: true

  scope :by_ids, ->ids{where id: ids}

  delegate :name, to: :rule, prefix: true, allow_nil: :true
end
