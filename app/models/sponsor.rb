class Sponsor < ApplicationRecord
  serialize :purpose
  serialize :experience, Hash
  serialize :organizational_units
  serialize :communication_plan
  serialize :participating_units

  belongs_to :organization
  belongs_to :club
  belongs_to :user

  enum status: {pending: 0, accept: 1, rejected: 2}

  scope :newest, ->{order created_at: :desc}

  delegate :name, to: :club, prefix: true, allow_nil: :true
end
