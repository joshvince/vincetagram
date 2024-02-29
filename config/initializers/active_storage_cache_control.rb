# frozen_string_literal: true

# This over-rides the active storage's #show method to add the caching headers to images
Rails.application.reloader.to_prepare do
  ActiveStorage::DiskController.class_eval do
    before_action only: [:show] do
      response.set_header('Cache-Control', 'max-age=31536000, immutable')
    end
  end
end
