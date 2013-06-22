class CreateImporters < ActiveRecord::Migration
  def change
    create_table :importers do |t|
      t.integer :status
      t.belongs_to :importable, :polymorphic => true
      t.belongs_to :user
      t.string :name
      t.string :file
      t.string :type
      t.string :error_message
      t.string :progress

      t.timestamps
    end
  end
end
