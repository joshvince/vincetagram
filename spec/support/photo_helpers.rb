# frozen_string_literal: true

module PhotoHelpers
  def solid_photo(width:, height:, rgb:)
    path = Rails.root.join('tmp', "solid-#{width}x#{height}-#{rgb.join('-')}.png")
    Vips::Image.black(width, height).new_from_image(rgb).cast(:uchar).copy(interpretation: :srgb).pngsave(path.to_s)
    { io: File.open(path), filename: 'photo.png', content_type: 'image/png' }
  end
end

RSpec.configure { |config| config.include PhotoHelpers }
