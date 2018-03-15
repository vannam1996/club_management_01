class EventDetail < ApplicationRecord
  acts_as_paranoid

  enum style: {pay: 0, get: 1}

  belongs_to :event

  scope :by_style, ->style{where style: style}
end
