class Property < ApplicationRecord
  has_many :property_neighbourhoods, inverse_of: :property, dependent: :destroy
  has_many :neighbourhoods, through: :property_neighbourhoods
  has_many :city_gems, through: :neighbourhoods

  validates :title, presence: true, length: { maximum: 160 }

  def guest_neighbourhoods
    neighbourhoods.where(neighbourhoods: { published: true }, property_neighbourhoods: { published: true })
  end

  def guest_city_gems
    CityGem.published.where(neighbourhood_id: guest_neighbourhoods.select(:id))
  end
end
