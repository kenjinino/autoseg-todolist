class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.references :user
      t.references :todolist

      t.timestamps
    end
    add_index :bookmarks, :user_id
    add_index :bookmarks, :todolist_id
    add_index :bookmarks, [:user_id, :todolist_id], unique: true
  end
end
