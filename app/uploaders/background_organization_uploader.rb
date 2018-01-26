class BackgroundOrganizationUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    "placeholders/photos/" + [version_name, "photo28.jpg"].compact.join("_")
  end

  version :thumb do
    process :crop_image
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def crop_image
    if model.bgr_crop_x.present?
      manipulate! do |img|
        x = model.bgr_crop_x.to_i
        y = model.bgr_crop_y.to_i
        w = model.bgr_crop_w.to_i
        h = model.bgr_crop_h.to_i
        img.crop "#{w}x#{h}+#{x}+#{y}"
      end
    end
  end
end
