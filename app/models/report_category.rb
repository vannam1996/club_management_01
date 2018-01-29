class ReportCategory < ApplicationRecord
  has_many :report_details, dependent: :destroy
  belongs_to :organization

  serialize :style_event, Array

  enum status: {obligatory: 1, optional: 0}
  enum status_active: {active: 1, not_active: 0}
  enum style: {money: 1, activity: 2, other: 3}

  scope :order_desc, ->{order created_at: :desc}
  scope :load_category, ->{where.not style_event: nil}
  scope :by_category, ->organization{where organization_id: organization}

  validates :name, presence: true, length: {maximum: Settings.max_name_category},
    uniqueness: {scope: :organization_id}
end
