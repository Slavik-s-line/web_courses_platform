class CourseTag < ApplicationRecord
  belongs_to :course
  belongs_to :tag, counter_cache: true
  # Tag.find_each { |tag| Tag.reset_counters(tag.id, :course_tags) }

  def self.ransackable_attributes(auth_object = nil)
    ["course_id", "id", "tag_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["course", "tag"]
  end
end
