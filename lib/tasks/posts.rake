# frozen_string_literal: true

namespace :posts do
  desc 'Record the size and tint of every photo, and generate its display copy'
  task process_photos: :environment do
    Post.includes(photo_attachment: :blob).find_each do |post|
      next unless post.photo.attached?

      post.photo.blob.analyze
      post.photo.variant(:display).processed
      puts "Processed post #{post.id}"
    rescue ActiveStorage::FileNotFoundError
      warn "Skipped post #{post.id}: its photo file is missing"
    end
  end
end
