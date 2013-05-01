class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.text :content
      t.references :todolist

      t.timestamps
    end
    add_index :todos, :todolist_id
  end
end
