class CreateRoleUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :role_users do |t|
      t.integer :role_id
      t.integer :user_id

      t.timestamps
    end
  end
end
