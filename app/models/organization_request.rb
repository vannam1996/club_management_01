class OrganizationRequest < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_many :activities, as: :target

  enum status: {pending: 0, joined: 1, reject: 2}

  mount_uploader :logo, ImageUploader

  validates :name, presence: true, uniqueness: true,
    length: {maximum: Settings.organization_request.max_name_length}
  validates :email, presence: true, uniqueness: true
  validates :description, presence: true,
    length: {maximum: Settings.organization_request.max_description_length}
  validates :phone,
    length: {maximum: Settings.organization_request.max_phone_number_length,
      minimum: Settings.organization_request.min_phone_number_length},
      allow_blank: true
  validates :location,
    length: {maximum: Settings.organization_request.max_location_length},
      allow_blank: true

  delegate :full_name, to: :user, allow_nil: :true

  scope :unapprove, ->{where approve: false}
  scope :newest, ->{order created_at: :desc}
end
