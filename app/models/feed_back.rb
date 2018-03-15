class FeedBack < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  validates :description, presence: true,
    length: {minimum: Settings.feed_back.min_content}

  enum type_feed_back: [:other, :web_content, :process, :ui]

  scope :newest, ->{order created_at: :desc}
end
