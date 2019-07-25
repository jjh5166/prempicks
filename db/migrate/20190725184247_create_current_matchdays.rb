class CreateCurrentMatchdays < ActiveRecord::Migration[5.2]
  def change
    create_table :current_matchdays do |t|
      t.integer :singleton_guard
      t.integer :matchday
      t.timestamps
    end
    add_index(:current_matchdays, :singleton_guard, :unique => true)
  end
end
