class WarningReport < ApplicationRecord
  belongs_to :club

  serialize :user_read, Array

  scope :by_club, ->club_ids{where club_id: club_ids}
  scope :newest, ->{order id: :desc}

  delegate :name, :logo, to: :club, prefix: :club, allow_nil: :true
end
