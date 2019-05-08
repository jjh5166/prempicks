class AddIndexScoringHelper < ActiveRecord::Migration[5.2]
  def change
    add_index :scores, :points
  end
end
