class Tag < ApplicationRecord
  normalizes :hashtag, with: ->(value) { value.strip.delete_prefix("#").downcase }

  has_many :neighbourhoods, dependent: :restrict_with_error
  has_many :city_gems, dependent: :restrict_with_error

  validates :title, presence: true, length: { maximum: 120 }
  validates :hashtag, presence: true, uniqueness: true, length: { maximum: 64 },
                      format: { with: /\A[a-z0-9_]+\z/ }

  def name
    title
  end
end
