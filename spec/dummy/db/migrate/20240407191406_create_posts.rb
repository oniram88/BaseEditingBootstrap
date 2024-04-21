class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :description
      t.string :category
      t.integer :read_counter
      t.date :published_at
      t.float :rating
      t.decimal :decimal_test_number, precision: 10, scale: 3

      t.timestamps
    end
  end
end
