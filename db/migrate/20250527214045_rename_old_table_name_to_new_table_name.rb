class RenameOldTableNameToNewTableName < ActiveRecord::Migration[7.1]
  def change
    rename_table :aiagent_inboxes, :aiagent_inboxes
  end
end
