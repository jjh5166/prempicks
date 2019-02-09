class CreateMatchdays < ActiveRecord::Migration[5.2]
  def change
    create_table :matchdays do |t|
      t.integer :week, null: false
      t.boolean :locked, default: false

      t.timestamps
    end
  end
end
