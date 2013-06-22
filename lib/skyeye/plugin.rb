# encoding: utf-8
module Skyeye
  def self.plugins
    @plugins ||= Plugins.new
  end

  class Plugins < Array
    def find_by_name(name)
      detect { |plugin| plugin.name == name }
    end

    def names
      map(&:name)
    end

    def titles
      map(&:title)
    end

    def scope(name)
      select { |plugin| plugin.scope.include?(name.to_sym) }
    end
  end

  # === Example
  #   Skyeye::Plugin.register do |plugin|
  #     plugin.name          = "court"
  #     plugin.version       = ""
  #     plugin.company_crawl = [:court]
  #     plugin.enable        = true
  #   
  #     plugin.access_control do
  #       permission :bill, [:read, :create, :destroy]
  #     end
  #   
  #     plugin.cancan do |user|
  #       can :read, Bill  if user.cando.bill.read
  #     end
  #   end
  class Plugin
    # 插件名字，版本
    attr_accessor :name, :version

    # 插件需要抓取的数据
    attr_accessor :company_crawl 

    # 插件的首页地址
    attr_accessor :mount_path 
    alias_method  :mount_at,   :mount_path

    # 插件的作用范围，即属于那一类的插件(如：公司, 公司客户等)，
    # 会影响到插件在系统中不同的显示集成
    attr_accessor :scope

    # 插件的cancan权限配置
    attr_reader :cancan_block

    # 插件默认的许可操作
    attr_accessor :permissions_access

    # 插件的cell
    attr_accessor :cell

    # 插件的资源
    attr_accessor :resources
    
    def self.register
      plugin = new

      Skyeye.plugins << plugin

      yield plugin

      plugin.register_crawl_resources

      plugin
    end

    def initialize
      @scope = [:system]
      @permissions_access = {}
      @company_crawl = []
      @resources = []
    end

    def add_resource(res)
      resources << res
    end

    def access_control(&block)
      Skyeye::AccessControl.map(name, &block)
    end

    def cancan(&block)
      @cancan_block = block
    end

    def permissions_access=(access = {})
      @permissions_access = access
    end

    # Translate i18n as a plugin title
    #
    # === Example
    #   skyeye:
    #     plugins:
    #       court:
    #         title: 法院信息
    def title
      I18n.t(["skyeye", "plugins", name, "title"].join("."))
    end

    def register_crawl_resources
      CompanySpider.crawl_resources.concat company_crawl if company_crawl.present?
    end
  end
end
