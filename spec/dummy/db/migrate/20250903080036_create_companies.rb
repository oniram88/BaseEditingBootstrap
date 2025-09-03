class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.string :name

      t.timestamps
    end

    create_table :addresses do |t|
      t.references :company
      t.string :street
      t.string :cap
      t.string :city

      t.timestamps
    end
  end
end
