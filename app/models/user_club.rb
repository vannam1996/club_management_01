class UserClub < ApplicationRecord
  belongs_to :user
  belongs_to :club

  has_many :activities, as: :trackable, dependent: :destroy

  enum status: {pending: 0, joined: 1, reject: 2}

  scope :manager, ->{where is_manager: true}
  scope :are_member, ->{where is_manager: false}
  scope :unactive, ->{where.not(status: UserClub.statuses[:joined])}
  scope :user_club, ->club_id do
    where club_id: club_id
  end
  scope :find_with_user_of_club, ->user_id, club_id do
    find_by user_id: user_id, club_id: club_id
  end
  scope :newest, ->{order created_at: :desc}
  scope :load_is_admin, ->club_id{where club_id: club_id}

  class << self
    def of_club club
      find_by club: club
    end

    def verify_manager? user
      user = find_by(id: user.id)
      return user.is_manager if user
      false
    end
  end

  delegate :name, :logo, :notification, :money, to: :club, allow_nil: :true
  delegate :full_name, :avatar, :email, :phone, to: :user, allow_nil: :true
end
