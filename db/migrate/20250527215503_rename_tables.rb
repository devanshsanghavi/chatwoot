class RenameTables < ActiveRecord::Migration[7.1]
  def change
    rename_table :captain_assistants, :aiagent_topics
    rename_table :captain_assistant_responses, :aiagent_topic_responses
    rename_table :captain_documents, :aiagent_documents
  end
end
