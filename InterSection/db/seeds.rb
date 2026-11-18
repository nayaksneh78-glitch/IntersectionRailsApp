if ENV["DEMO_DATA"] == "1"
  ApplicationRecord.transaction do
    property = Property.find_or_create_by!(title: "Garden House") do |record|
      record.description = "Coffee, green spaces and a few favourite stops around Bengaluru."
    end
    local = Tag.find_or_create_by!(hashtag: "local_favourite") { |record| record.title = "Local favourite" }
    outdoors = Tag.find_or_create_by!(hashtag: "outdoors") { |record| record.title = "Outdoors" }
    coffee = Category.find_or_create_by!(title: "Coffee & food")
    parks = Category.find_or_create_by!(title: "Parks & walks")
    neighbourhood = Neighbourhood.find_or_create_by!(title: "South Bengaluru", tag: local) do |record|
      record.description = "Tree-lined streets, historic cafés and gardens."
      record.published = true
    end
    PropertyNeighbourhood.find_or_create_by!(property: property, neighbourhood: neighbourhood) do |record|
      record.published = true
    end

    CityGem.find_or_create_by!(title: "Lalbagh Botanical Garden", neighbourhood: neighbourhood) do |record|
      record.assign_attributes(category: parks, tag: outdoors, published: true,
                               short_desc: "A spacious botanical garden for a slow morning walk.",
                               long_desc: "Take the paths around the lake or head towards the glasshouse.",
                               location: "Lalbagh Road, Bengaluru")
    end
    CityGem.find_or_create_by!(title: "Vidyarthi Bhavan", neighbourhood: neighbourhood) do |record|
      record.assign_attributes(category: coffee, tag: local, published: true,
                               short_desc: "A Basavanagudi landmark for a classic dosa and filter coffee.",
                               location: "Gandhi Bazaar Main Road, Basavanagudi, Bengaluru")
    end
  end
end
