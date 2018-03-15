class Admin < ApplicationRecord
  acts_as_paranoid

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable

  has_many :notifications, as: :target, dependent: :destroy
  has_many :activities, as: :person_target, dependent: :destroy

  mount_uploader :avatar, AvatarUploader
end
