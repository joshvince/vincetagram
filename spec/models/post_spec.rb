# frozen_string_literal: true

require 'rails_helper'
require 'support/photo_helpers'

RSpec.describe Post, type: :model do
  let(:user) { User.create!(name: 'Jo Bloggs', email: 'jo@example.com') }

  it 'keeps one display copy of a photo, 1440px wide and saved as WebP' do
    photo = described_class.create!(user:, photo: solid_photo(width: 3000, height: 2000, rgb: [200, 100, 50])).photo

    copy = Vips::Image.new_from_buffer(photo.variant(:display).processed.download, '')

    expect([copy.width, copy.height, copy.get('vips-loader')]).to eq([1440, 960, 'webpload_buffer'])
  end
end
