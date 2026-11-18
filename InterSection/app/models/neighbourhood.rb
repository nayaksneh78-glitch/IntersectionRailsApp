class Neighbourhood < ApplicationRecord
  belongs_to :tag
  has_many :property_neighbourhoods, dependent: :destroy
  has_many :properties, through: :property_neighbourhoods
  has_many :city_gems, dependent: :destroy

  validates :published, inclusion: { in: [true, false] }
  validates :title, presence: true, length: { maximum: 160 }
end
