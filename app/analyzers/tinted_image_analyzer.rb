# frozen_string_literal: true

# Adds the image's average colour as `tint` alongside the width and height
# Active Storage already records. The feed uses it to colour each caption plate
# and as the placeholder while the photo loads.
class TintedImageAnalyzer < ActiveStorage::Analyzer::ImageAnalyzer::Vips
  private

  def read_image
    super do |image|
      yield(image).merge(tint: average_colour(image))
    end
  end

  def average_colour(image)
    stats = image.colourspace(:srgb).extract_band(0, n: 3).stats
    red, green, blue = (1..3).map { |band| stats.getpoint(4, band).first.round }
    format('#%<red>02x%<green>02x%<blue>02x', red:, green:, blue:)
  rescue ::Vips::Error => e
    logger.error "Skipping image tint due to a Vips error: #{e.message}"
    nil
  end
end
