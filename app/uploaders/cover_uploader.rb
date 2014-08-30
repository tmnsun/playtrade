# encoding: utf-8

# Game cover image
class CoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  process resize_to_fit: [600, 600]
  process convert: 'png'

  version :thumb do
    process resize_to_fill: [160, 160]
  end

  def default_url
    ActionController::Base.helpers.asset_path("fallback/" + [version_name, "cover.png"].compact.join('_'))
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
    'cover.png' if original_filename.present?
  end
end
