class CreateUserPlugins < ActiveRecord::Migration
  def change
    create_table :user_plugins do |t|
      t.belongs_to :user,        :null => false
      t.string     :plugin_name, :null => false

      t.timestamps
    end

    add_index :user_plugins, :plugin_name

    user = User.where(name: "shenchao").first || User.create(name: "shenchao", password: "123456", email: "shenchao@qqw.com.cn")
    plugin = UserPlugin.new(:plugin_name => "skyeye_apollo")
    plugin.user = user
    plugin.save
  end
end
