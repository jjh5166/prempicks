class AddColumnToMatchdays < ActiveRecord::Migration[5.2]
  def change
    add_column :matchdays, :scored, :boolean, default: false
  end
end
