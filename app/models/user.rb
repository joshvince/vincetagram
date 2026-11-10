# frozen_string_literal: true

class User < ApplicationRecord
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  passwordless_with :email
  has_many :posts, dependent: :destroy

  def initials
    name.split.map(&:first).take(2).join.upcase
  end

  # A stable hue per person, so their avatar and name keep the same colour everywhere.
  def hue
    Zlib.crc32(id.to_s) % 360
  end

  def last_signed_in_at
    passwordless_sessions.where.not(claimed_at: nil).order(claimed_at: :desc).first&.claimed_at
  end
end
