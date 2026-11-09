# frozen_string_literal: true

require 'rails_helper'
require 'support/photo_helpers'

RSpec.describe TintedImageAnalyzer do
  it 'records the size and average colour of a photo' do
    blob = ActiveStorage::Blob.create_and_upload!(**solid_photo(width: 40, height: 20, rgb: [51, 102, 204]))

    blob.analyze

    expect(blob.metadata).to include(width: 40, height: 20, tint: '#3366cc')
  end
end
