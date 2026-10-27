# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Signing in', type: :request do
  let!(:user) { User.create!(name: 'Jo Bloggs', email: 'jo@example.com') }

  def emailed_link
    ActionMailer::Base.deliveries.last.body.to_s[%r{http://\S+/sign_in/\S+/\S+}]
  end

  before { ActionMailer::Base.deliveries.clear }

  it 'shows the invite-only sign in page' do
    get '/sign_in'

    expect(response.body).to include('This site is invite only', 'Send a magic link')
  end

  it 'emails a magic link that signs the user in once' do
    post '/sign_in', params: { passwordless: { email: 'Jo@Example.com ' } }

    expect(response).to redirect_to(%r{/sign_in/[\w-]+\z})
    expect(ActionMailer::Base.deliveries.last.subject).to eq('Log in to Vincetagram: Your magic link ✨')

    link = emailed_link
    get link
    expect(response).to redirect_to('/feed')
    follow_redirect!
    expect(response).to have_http_status(:ok)

    delete '/sign_out'
    get link
    expect(response).to redirect_to('/sign_in')
    expect(flash[:alert]).to include('already been used')
  end

  it 'signs the user in with the code from the email' do
    post '/sign_in', params: { passwordless: { email: user.email } }
    verify_path = response.location
    code = ActionMailer::Base.deliveries.last.body.to_s[/sign in page: (\w+)/, 1]

    patch verify_path, params: { passwordless: { token: 'WRONG1' } }
    expect(response).to have_http_status(:forbidden)

    patch verify_path, params: { passwordless: { token: code } }
    expect(response).to redirect_to('/feed')
  end

  it "doesn't reveal whether an email belongs to someone" do
    post '/sign_in', params: { passwordless: { email: 'stranger@example.com' } }

    expect(response).to redirect_to(%r{/sign_in/[\w-]+\z})
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  it 'keeps people signed in from sessions created before passwordless 1.0' do
    post '/sign_in', params: { passwordless: { email: user.email } }
    get emailed_link
    Passwordless::Session.last.update_columns(identifier: nil, token_digest: nil)

    get '/feed'
    expect(response).to have_http_status(:ok)
  end

  describe 'admin sign-in links' do
    let!(:admin) { User.create!(name: 'Ad Min', email: 'admin@example.com', admin: true) }

    def sign_in_as(someone)
      post '/sign_in', params: { passwordless: { email: someone.email } }
      get emailed_link
    end

    it 'lets an admin create a link that signs the user in' do
      sign_in_as(admin)

      post user_sign_in_link_path(user), as: :turbo_stream
      link = response.body[%r{http://\S+/sign_in/[^<\s]+}]
      expect(link).to be_present

      delete '/sign_out'
      get link
      expect(response).to redirect_to('/feed')
      expect(Passwordless::Session.last.authenticatable).to eq(user)
    end

    it "doesn't let anyone else create links" do
      sign_in_as(user)

      expect { post user_sign_in_link_path(user), as: :turbo_stream }
        .not_to change(Passwordless::Session, :count)
      expect(response).to redirect_to('/feed')
    end
  end
end
