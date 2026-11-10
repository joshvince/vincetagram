# frozen_string_literal: true

namespace :posts do
  desc 'Record the size and tint of every photo, generate its display copy, then delete its older copies'
  task process_photos: :environment do
    Post.includes(photo_attachment: :blob).find_each do |post|
      next unless post.photo.attached?

      post.photo.blob.analyze
      display = post.photo.variant(:display).processed
      unless display.image.blob.service.exist?(display.key)
        warn "Kept older copies of post #{post.id}: its display copy is missing"
        next
      end

      post.photo.blob.variant_records.where.not(variation_digest: display.variation.digest).find_each do |old_copy|
        old_copy.image.purge
        old_copy.destroy!
      end
      puts "Processed post #{post.id}"
    rescue ActiveStorage::FileNotFoundError
      warn "Skipped post #{post.id}: its photo file is missing"
    end
  end
end
