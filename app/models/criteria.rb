class Criteria < ApplicationRecord
  acts_as_paranoid

  has_many :criteria_details, dependent: :destroy
  belongs_to :organization
end
