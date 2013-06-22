class CreateExporters < ActiveRecord::Migration
  def change
    create_table :exporters do |t|
      t.belongs_to :user

      t.string  :format
      t.string  :file_path
      t.text    :options
      t.string  :content_type
      t.integer :status, :default => 0

      t.timestamps
    end
  end
end
