# frozen_string_literal: true

namespace :posts do
  desc 'Record the size and tint of every photo, and generate its display sizes'
  task process_photos: :environment do
    Post.includes(photo_attachment: :blob).find_each do |post|
      next unless post.photo.attached?

      post.photo.blob.analyze
      Post::PHOTO_WIDTHS.each_key { |name| post.photo.variant(name).processed }
      puts "Processed post #{post.id}"
    rescue ActiveStorage::FileNotFoundError
      warn "Skipped post #{post.id}: its photo file is missing"
    end
  end
end
