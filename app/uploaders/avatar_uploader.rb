class AvatarUploader < CarrierWave::Uploader::Base
  storage :file

  def size_range
    0..Settings.user.avatar.size.megabytes
  end

  def extension_whitelist
    Settings.user.avatar.accept_types
  end

  def default_url
    ActionController::Base
      .helpers.asset_path([version_name, "avatar.jpg"].compact.join("_"))
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end
end
