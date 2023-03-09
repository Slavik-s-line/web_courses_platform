class User < ApplicationRecord
  has_many :courses
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable, :registerable,  :trackable,
         :recoverable, :rememberable, :validatable, :confirmable

  def to_s
    email
  end
end
