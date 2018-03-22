class TargetHobbiesTag < ApplicationRecord
  belongs_to :hobbies_tag
  belongs_to :target, polymorphic: true
end
