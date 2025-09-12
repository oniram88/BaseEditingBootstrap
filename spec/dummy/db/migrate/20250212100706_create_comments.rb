class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :comment
      t.belongs_to :commentable, polymorphic: true
      t.timestamps
    end

  end
end
