class CreatePicks < ActiveRecord::Migration[5.2]
  def change
    create_table :picks do |t|
      t.integer  :user_id
      t.string   :team_id
      t.integer  :matchday
      t.integer  :points
      t.integer  :half
      t.timestamps
    end
  end
end
