class OrganizationSetting < ApplicationRecord
  belongs_to :organization

  scope :of_key, ->key{where key: key}
end
