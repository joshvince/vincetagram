# frozen_string_literal: true

require 'rails_helper'
require 'support/photo_helpers'

RSpec.describe 'The feed', type: :request do
  let(:user) { User.create!(name: 'Jo Bloggs', email: 'jo@example.com') }
  let(:post_with_photo) do
    Post.create!(user:, caption: 'Low tide', photo: solid_photo(width: 900, height: 300, rgb: [10, 20, 30]))
  end

  before { post_with_photo.photo.blob.analyze }

  def sign_in(user)
    magic_link = Passwordless::Session.create!(authenticatable: user)
    get "/sign_in/#{magic_link.identifier}/#{magic_link.token}"
  end

  it 'serves each photo at three widths, cropped and tinted for the feed' do
    sign_in(user)

    get feed_post_path(post_with_photo)

    expect(response.body).to include('720w', '1440w', '2160w', 'aspect-ratio: 2 / 1', '--tint: #0a141e', 'Low tide')
  end

  it 'shows a shared post, uncropped, to someone who is signed out' do
    get post_path(post_with_photo)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('aspect-ratio: 3 / 1', 'Copy link to this post')
    expect(response.body).not_to include('class="dock')
  end
end
