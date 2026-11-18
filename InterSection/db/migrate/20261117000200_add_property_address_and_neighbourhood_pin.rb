class AddPropertyAddressAndNeighbourhoodPin < ActiveRecord::Migration[7.2]
  class PropertyRow < ActiveRecord::Base
    self.table_name = "properties"
  end

  class NeighbourhoodRow < ActiveRecord::Base
    self.table_name = "neighbourhoods"
  end

  def up
    add_column :properties, :address, :string
    add_column :neighbourhoods, :pin, :string
    PropertyRow.reset_column_information
    NeighbourhoodRow.reset_column_information

    PropertyRow.where(title: ["Section L Hatchobori", "Section L Ginza East", "Section L Residence Ginza"]).find_each do |property|
      description, separator, address = property.description.to_s.rpartition("\n")
      next if separator.empty? || !address.match?(/, Chuo City, Tokyo \d{3}-\d{4}\z/)

      property.update_columns(address: address, description: description)
    end

    NeighbourhoodRow.where(title: %w[Hatchobori Tsukiji Ginza]).find_each do |neighbourhood|
      description = neighbourhood.description.to_s
      match = description.match(/^Tokyo · (?<pin>-?\d+\.\d+, -?\d+\.\d+)\r?$/)
      next unless match

      neighbourhood.update_columns(pin: match[:pin], description: description.sub(match[0], "Tokyo"))
    end
  end

  def down
    PropertyRow.reset_column_information
    NeighbourhoodRow.reset_column_information

    PropertyRow.where.not(address: [nil, ""]).find_each do |property|
      property.update_columns(description: [property.description.presence, property.address].compact.join("\n"))
    end

    NeighbourhoodRow.where.not(pin: [nil, ""]).find_each do |neighbourhood|
      description = neighbourhood.description.to_s
      restored = if description.match?(/^Tokyo$/)
        description.sub(/^Tokyo$/, "Tokyo · #{neighbourhood.pin}")
      else
        [description.presence, "Map pin: #{neighbourhood.pin}"].compact.join("\n")
      end
      neighbourhood.update_columns(description: restored)
    end

    remove_column :neighbourhoods, :pin
    remove_column :properties, :address
  end
end
