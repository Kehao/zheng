class CreateImporterExceptionTemps < ActiveRecord::Migration
  def change
    create_table :importer_exception_temps do |t|
      t.belongs_to :user,:default=>nil
      t.belongs_to :importer,:default=>nil
      t.text :data,:null => false
      t.string :exception_msg
      t.integer :status,:default => 0

      t.timestamps
    end
  end
end
