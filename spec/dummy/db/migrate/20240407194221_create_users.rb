class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.boolean :enabled

      t.timestamps
    end
  end
end
