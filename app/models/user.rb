class User < ApplicationRecord
  has_secure_password

  has_many :contents, dependent: :destroy

  before_save :downcase_email

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  private

  def downcase_email
    self.email = email.downcase
  end
end
