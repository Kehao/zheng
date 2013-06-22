class CreateExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.references :user
      t.integer    :category
      t.string     :response_url
      
      t.timestamps
    end
  end
end
