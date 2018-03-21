class Evaluate < ApplicationRecord
  acts_as_paranoid

  belongs_to :club
  belongs_to :user
  has_many :evaluate_details, dependent: :destroy

  scope :newest, ->{order created_at: :desc}

  delegate :full_name, :avatar, to: :user, prefix: :user
end
