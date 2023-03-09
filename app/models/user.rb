class User < ApplicationRecord
  has_many :courses
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable, :registerable,  :trackable,
         :recoverable, :rememberable, :validatable, :confirmable

  def to_s
    email
  end

  def self.ransackable_attributes(auth_object = nil)
    ["confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at", "current_sign_in_at", "current_sign_in_ip", "email", "encrypted_password", "id", "last_sign_in_at", "last_sign_in_ip", "remember_created_at", "reset_password_sent_at", "reset_password_token", "sign_in_count", "unconfirmed_email", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["courses"]
  end
end
