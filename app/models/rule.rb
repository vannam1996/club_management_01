class Rule < ApplicationRecord
  acts_as_paranoid

  has_many :rule_details, dependent: :destroy
  belongs_to :organization

  validates :name, presence: true

  accepts_nested_attributes_for :rule_details, allow_destroy: true,
    reject_if: proc {|attributes| attributes[:content].blank?}

  scope :newest, ->{order created_at: :desc}
end
