class PostGallery < ApplicationRecord
  enum style: {image: 1, video: 2}

  belongs_to :post

  mount_uploader :url, ImageUploader
end
