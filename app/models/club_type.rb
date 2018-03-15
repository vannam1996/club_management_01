class ClubType < ApplicationRecord
  acts_as_paranoid

  belongs_to :organization
  has_many :clubs, dependent: :destroy
  has_many :club_requests, dependent: :destroy

  scope :of_organization, ->(organization_id){where organization_id: organization_id}
  scope :order_desc, ->{order created_at: :desc}

  validates :name, presence: true, length: {maximum: Settings.name_type},
    uniqueness: {scope: :organization_id}

  delegate :name, to: :organization, prefix: :organization, allow_nil: :true
end
