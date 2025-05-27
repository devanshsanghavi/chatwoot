class RenameOldTableNameToNewTableName < ActiveRecord::Migration[7.1]
  def change
    rename_table :captain_inboxes, :aiagent_inboxes
  end
end
