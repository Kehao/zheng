class AddSentApolloToNotice < ActiveRecord::Migration
  def change
    add_column :notices, :sent_to_apollo, :boolean, default:false
  end
end
