# frozen_string_literal: true

module ApplicationHelper
  def icon(name, **options)
    tag.svg tag.use(href: "#i-#{name}"),
            class: class_names('i', options.delete(:class)), 'aria-hidden': true, **options
  end

  def avatar(user, size: nil)
    tag.span(user.initials, class: class_names('av', "av--#{size}" => size), style: "--h: #{user.hue}")
  end
end
