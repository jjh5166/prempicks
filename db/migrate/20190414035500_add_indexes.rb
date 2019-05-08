class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :picks, :user_id
    add_index :picks, [:user_id, :matchday], name: 'user_pick', unique: true
    add_index :picks, [:user_id, :half], name: 'half_picks'
  end
end
