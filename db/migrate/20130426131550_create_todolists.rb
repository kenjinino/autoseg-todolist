class CreateTodolists < ActiveRecord::Migration
  def change
    create_table :todolists do |t|
      t.string :title
      t.boolean :public
      t.references :user

      t.timestamps
    end
    add_index :todolists, :user_id
  end
end
