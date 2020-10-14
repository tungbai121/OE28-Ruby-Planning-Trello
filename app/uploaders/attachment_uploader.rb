class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def size_range
    0..Settings.attachment.size.megabytes
  end

  version :thumb do
    process resize_to_fill:
      [Settings.attachment.thumb.width, Settings.attachment.thumb.height],
        if: :image?
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  private

  def image? file
    file.content_type.start_with? "image"
  end
end
