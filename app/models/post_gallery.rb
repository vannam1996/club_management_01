class PostGallery < ApplicationRecord
  belongs_to :post

  mount_uploader :url, ImageUploader
end
