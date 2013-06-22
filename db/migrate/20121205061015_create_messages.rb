class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string     :recipient_id, :null => false
      t.belongs_to :event, :polymorphic => true
      t.boolean    :read, :default => false

      t.timestamps
    end

    add_index :messages, :recipient_id
  end
end
