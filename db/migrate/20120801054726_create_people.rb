class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :number

      t.boolean :court_crawled,     default: false
      t.boolean :idinfo_crawled,    default: false
      t.boolean :sentiment_crawled, default: false

      t.timestamps
    end
  end
end
