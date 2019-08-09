class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :picks, dependent: :destroy, inverse_of: :user
  has_many :guest_picks, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :picks, :guest_picks
  validates_associated :picks, :guest_picks
  validate :password_complexity
  after_create :send_sign_up_emails, :seed_picks

  private

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password, 'Complexity requirement not met. Length should be at least 8 and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end

  def send_sign_up_emails
    UserMailer.new_sign_up_email(self).deliver_later
    return if self.guest

    UserMailer.welcome_email(self).deliver_later
  end

  def seed_picks
    return if self.guest

    (1..38).each do |n|
      h = n < 20 ? 1 : 2
      Pick.new(user_id: self.id, matchday: n, half: h).save
    end
  end
end
