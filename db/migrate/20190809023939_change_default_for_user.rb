class ChangeDefaultForUser < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :guest, false
  end
end
