class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.integer :matchday, null: false
      t.integer :points, default: 0
      t.string :team_id, null: false
      t.timestamps
    end
    add_index :scores, [:team_id, :matchday], name: 'score_key', unique: true
  end
end
