class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name

      t.timestamps
    end

    create_table :addresses do |t|
      t.belongs_to :addressable, polymorphic: true
      t.string :street
      t.string :cap
      t.string :city

      t.timestamps
    end
  end
end
