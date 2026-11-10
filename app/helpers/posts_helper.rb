# frozen_string_literal: true

module PostsHelper
  # The feed crops very tall or very wide photos; the post page shows them whole.
  def post_media_style(post, crop: false)
    ratio = crop ? post.aspect_ratio.clamp(Rational(4, 5), Rational(2, 1)) : post.aspect_ratio
    "aspect-ratio: #{ratio.numerator} / #{ratio.denominator}; --ar: #{ratio.numerator} / #{ratio.denominator}"
  end

  def post_tint_style(post)
    "--tint: #{post.tint}" if post.tint
  end
end
