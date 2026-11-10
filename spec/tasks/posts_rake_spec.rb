# frozen_string_literal: true

require 'rails_helper'
require 'rake'
require 'support/photo_helpers'

RSpec.describe 'posts:process_photos' do
  let(:user) { User.create!(name: 'Jo Bloggs', email: 'jo@example.com') }
  let(:post) { Post.create!(user:, photo: solid_photo(width: 1200, height: 800, rgb: [10, 20, 30])) }

  before do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
    Rake::Task['posts:process_photos'].reenable
  end

  it 'replaces older copies with the display copy' do
    old_copy = post.photo.variant(resize_to_limit: [600, 600]).processed

    expect { Rake::Task['posts:process_photos'].invoke }.to output(/Processed post/).to_stdout

    display_digest = post.photo.variant(:display).variation.digest
    expect(post.photo.blob.variant_records.pluck(:variation_digest)).to eq([display_digest])
    expect(ActiveStorage::Blob.service.exist?(old_copy.key)).to be(false)
    expect(post.photo.blob.reload.metadata).to include('tint' => '#0a141e', 'width' => 1200)
  end
end
