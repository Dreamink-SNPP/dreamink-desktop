include UserScoped

class Idea < ApplicationRecord
  belongs_to :project

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :search, ->(query) { where("title LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%") }
  scope :tagged_with, ->(tag) { where("tags LIKE ?", "%#{tag}%") }

  def tag_list
    tags&.split(",")&.map(&:strip) || []
  end

  def tag_list=(new_tags)
    self.tags = Array(new_tags).join(", ")
  end
end
