# frozen_string_literal: true

# Runs before Active Storage copies this list into ActiveStorage.analyzers.
Rails.application.config.after_initialize do |app|
  app.config.active_storage.analyzers.prepend(TintedImageAnalyzer)
end
