class AddAiagentTopicIdToAiagentInboxes < ActiveRecord::Migration[7.1]
  def change
    add_column :aiagent_inboxes, :aiagent_topic_id, :integer
  end
end
