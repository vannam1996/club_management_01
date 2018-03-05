class Post < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true

  validates :name, presence: true
  validates :content, presence: true

  scope :newest, ->{order created_at: :desc}
end
