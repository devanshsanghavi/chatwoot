class RenameTables < ActiveRecord::Migration[7.1]
  def change
    rename_table :aiagent_topics, :aiagent_topics
    rename_table :aiagent_topic_responses, :aiagent_topic_responses
    rename_table :aiagent_documents, :aiagent_documents
  end
end
