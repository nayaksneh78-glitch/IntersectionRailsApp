class CreateInterSectionTables < ActiveRecord::Migration[7.2]
  def change
    create_table :admin_users do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.timestamps
      t.index :email, unique: true
    end

    create_table :properties do |t|
      t.string :title, null: false
      t.text :description
      t.timestamps
    end

    create_table :tags do |t|
      t.string :title, null: false
      t.string :hashtag, null: false
      t.text :description
      t.timestamps
      t.index :hashtag, unique: true
    end

    create_table :categories do |t|
      t.string :title, null: false
      t.text :description
      t.timestamps
    end

    create_table :neighbourhoods do |t|
      t.string :title, null: false
      t.text :description
      t.references :tag, null: false, foreign_key: true
      t.boolean :published, null: false, default: false
      t.timestamps
    end

    create_table :property_neighbourhoods do |t|
      t.references :property, null: false, foreign_key: true, index: false
      t.references :neighbourhood, null: false, foreign_key: true
      t.boolean :published, null: false, default: false
      t.timestamps
      t.index %i[property_id neighbourhood_id], unique: true
    end

    create_table :city_gems do |t|
      t.string :title, null: false
      t.string :short_desc, null: false
      t.text :long_desc
      t.text :image
      t.string :location, null: false
      t.references :tag, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :neighbourhood, null: false, foreign_key: true
      t.boolean :published, null: false, default: false
      t.timestamps
    end
  end
end
