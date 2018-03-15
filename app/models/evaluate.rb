class Evaluate < ApplicationRecord
  acts_as_paranoid

  belongs_to :club
  has_many :evaluate_details
end
