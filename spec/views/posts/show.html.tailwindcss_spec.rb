# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'posts/show', type: :view do
  before(:each) do
    assign(:post, Post.create!(
                    caption: 'MyText',
                    photo: nil
                  ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
