class Course < ApplicationRecord
  include ActionText::Attachable
  validates :title, :short_description, :language, :price, :level,  presence: true
  validates :description, presence: true, length: { :minimum => 5 }
  belongs_to :user, optional: true, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons

  validates :title, uniqueness: true

  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }

  def to_s
    title
  end

  has_rich_text :description

  extend FriendlyId
  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    title_changed?
  end

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  def self.languages
    ["English", "Russian", "Polish", "Spanish"]
  end

  def self.levels
    ["Beginner", "Intermediate", "Advanced"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "language", "level", "price", "short_description", "slug", "title", "updated_at", "user_id", "average_rating", "enrollments_count"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["rich_text_description", "user"]
  end

  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
  end

  def progress(user)
    unless self.lessons_count == 0
      (user_lessons.where(user: user).count/self.lessons_count).to_f*100
    end
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)
    end
  end
end
