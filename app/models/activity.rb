class Activity < ApplicationRecord
  belongs_to :trackable, polymorphic: true
  belongs_to :owner, polymorphic: true
  belongs_to :container, polymorphic: true

  has_many :comments, as: :target, dependent: :destroy
  enum read: {un_read: 0, readed: 1}

  after_create :push_notify

  serialize :user_read, Array

  scope :of_user_clubs, ->(ar_club_id) do
    where "container_id IN (?) AND container_type = ? OR trackable_id IN (?) AND trackable_type = ?" ,
      ar_club_id, Settings.notification_club, ar_club_id, Settings.notification_club
  end
  scope :oder_by_read, ->{order id: :desc}
  scope :notification_user, ->user_id{where.not owner_id: user_id}

  delegate :name, to: :container, prefix: :container, allow_nil: :true
  delegate :name, to: :trackable, prefix: :trackable, allow_nil: :true
  delegate :full_name, to: :owner, prefix: :owner, allow_nil: :true

  private
  def push_notify
    NotificationBroadcastJob.perform_now self, lists_received
  end

  def lists_received
    lists_received = self.container.users.try(:ids)
    lists_received.delete(self.owner_id)
    lists_received
  end
end
