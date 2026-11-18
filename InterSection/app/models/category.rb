class Category < ApplicationRecord
  has_many :city_gems, dependent: :restrict_with_error

  validates :title, presence: true, length: { maximum: 120 }

  def name
    title
  end
end
