class ClubType < ApplicationRecord
  belongs_to :organization
  has_many :clubs, dependent: :destroy
  has_many :club_requests, dependent: :destroy

  scope :load_club_type, ->(organization_id) {where organization_id: organization_id}

  validates :name, presence: true, length: {maximum: Settings.name_type}
end
