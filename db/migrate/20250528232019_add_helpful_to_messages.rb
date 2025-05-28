class AddHelpfulToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :helpful, :boolean
  end
end
