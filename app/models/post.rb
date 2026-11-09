# frozen_string_literal: true

class Post < ApplicationRecord
  PHOTO_WIDTHS = { small: 720, medium: 1440, large: 2160 }.freeze

  has_one_attached :photo do |attachable|
    PHOTO_WIDTHS.each do |name, width|
      attachable.variant name, resize_to_limit: [width, nil], saver: { quality: 85, keep: :icc }, preprocessed: true
    end
  end
  has_one_attached :video
  belongs_to :user

  def media
    return video if video.attached?

    photo
  end

  def aspect_ratio
    return Rational(16, 9) if video.attached?

    width, height = photo.metadata.values_at(:width, :height)
    width && height ? Rational(width, height) : Rational(4, 5)
  end

  def tint
    photo.metadata[:tint] if photo.attached?
  end

  def sync_file_to_archive
    full_path_to_file = "#{file_directory}/#{media.filename}"
    # Make the directory if it doesn't exist
    FileUtils.mkdir_p(file_directory)

    File.open(full_path_to_file, 'wb') do |file|
      media.blob.download do |blob|
        file.write blob
      end
    end
  end

  private

  def file_directory
    now = Time.zone.now
    root = Rails.configuration.x.archive_root
    decade_folder = (now.year / 10 * 10).to_s.concat('s')
    year_folder = now.year.to_s
    month_folder = now.strftime('%B %y')

    "#{root}/#{decade_folder}/#{year_folder}/#{month_folder}"
  end
end
