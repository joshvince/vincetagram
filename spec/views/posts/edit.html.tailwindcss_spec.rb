require 'rails_helper'

RSpec.describe "posts/edit", type: :view do
  let(:post) {
    Post.create!(
      caption: "MyText",
      photo: nil
    )
  }

  before(:each) do
    assign(:post, post)
  end

  it "renders the edit post form" do
    render

    assert_select "form[action=?][method=?]", post_path(post), "post" do

      assert_select "textarea[name=?]", "post[caption]"

      assert_select "input[name=?]", "post[photo]"
    end
  end
end
