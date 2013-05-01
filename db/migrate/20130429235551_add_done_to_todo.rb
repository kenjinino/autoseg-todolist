class AddDoneToTodo < ActiveRecord::Migration
  def change
    add_column :todos, :done, :boolean
  end
end
