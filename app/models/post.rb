# frozen_string_literal: true

class Post < ApplicationRecord
  has_one_attached :photo
  has_one_attached :video
  belongs_to :user

  def media
    return video if video.attached?

    photo
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
    root = ENV.fetch('FILE_STORAGE_ROOT', nil)
    decade_folder = (now.year / 10 * 10).to_s.concat('s')
    year_folder = now.year.to_s
    month_folder = now.strftime('%B %y')

    "#{root}/#{decade_folder}/#{year_folder}/#{month_folder}"
  end
end
