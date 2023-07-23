class User < ApplicationRecord
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  passwordless_with :email
  has_many :posts, dependent: :destroy

  def initials
    name.split.map { |word| word.first }.take(2).join.upcase
  end

  def last_signed_in_at
    passwordless_sessions.where.not(claimed_at: nil).order(claimed_at: :desc).first&.claimed_at
  end
end
