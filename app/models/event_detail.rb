class EventDetail < ApplicationRecord
  belongs_to :event

  enum style: {pay: 0, get: 1}
end
