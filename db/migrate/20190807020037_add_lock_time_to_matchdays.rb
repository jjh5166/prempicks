class AddLockTimeToMatchdays < ActiveRecord::Migration[5.2]
  def change
    add_column :matchdays, :lock_time, :datetime
  end
end
