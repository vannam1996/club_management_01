class Video < ApplicationRecord
  belongs_to :album
  belongs_to :user

  has_many :activities, as: :trackable, dependent: :destroy

  scope :newest, ->{order created_at: :desc}
  scope :upload_success, ->{where is_success: true}
end
