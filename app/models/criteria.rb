class Criteria < ApplicationRecord
  has_many :criteria_details, dependent: :destroy
  belongs_to :organization
end
