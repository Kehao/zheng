class AddUnreadMessagesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :unread_messages_count, "integer unsigned", :default => 0
  end
end
