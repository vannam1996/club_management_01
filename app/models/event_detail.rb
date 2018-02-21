class EventDetail < ApplicationRecord
  enum style: {pay: 0, get: 1}

  belongs_to :event

  scope :by_style, ->style{where style: style}
end
