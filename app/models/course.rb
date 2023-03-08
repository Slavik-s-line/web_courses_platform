class Course < ApplicationRecord
  include ActionText::Attachable
  validates :title,  presence: true
  validates :description, presence: true, length: { :minimum => 5 }
  belongs_to :user, optional: true

  def to_s
    title
  end

  has_rich_text :description
end
