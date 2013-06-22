class AddLastCrawledAtToSpiders < ActiveRecord::Migration
  def change
    add_column :spiders, :last_crawled_at, :datetime
  end
end
