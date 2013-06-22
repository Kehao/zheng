class AddTypeToSpider < ActiveRecord::Migration
  def change
    add_column :spiders, :type, :string  # to support single table inheritance
  end
end
