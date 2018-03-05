class Sponsor < ApplicationRecord
  serialize :purpose
  serialize :experience, Hash
  serialize :organizational_units
  serialize :communication_plan
  serialize :participating_units

  belongs_to :event
end
