class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.boolean :editable, default: true

      t.timestamps
    end

    create_table :base_addresses do |t|
      t.belongs_to :addressable, polymorphic: true
      t.string :street
      t.string :cap
      t.string :city
      t.string :type

      t.timestamps
    end
  end
end
