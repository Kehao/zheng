#encoding: utf-8
module Skyeye
  module AccessControl
    class << self
      # Map resource permissions.
      # permissions以scope分组，相同scope下，只有一个map实例，
      # 所以同一资源的permission只能设置一次
      #
      # === Parameters
      # * scope
      #   指定permissions的命名空间，默认nil为系统的permissions
      def map(scope = nil, &block)
        map = maps[scope] ||= Map.new(scope)

        map.instance_eval(&block)

        permissions.concat map.permissions
      end

      def permissions
        @permissions ||= Permissions.new
      end

      def maps
        @maps ||= {}
      end
    end

    class Map
      attr_reader :scope
      # === Parameters
      # * scope
      #   permission属于系统的或者插件的
      def initialize(scope)
        @scope = scope
      end

      def permission(resource, actions = [], options = {})
        permissions << Permission.new(resource, actions, options.reverse_merge!(scope: scope))
      end

      def permissions
        @permissions ||= Permissions.new
      end
    end

    class Permissions < Array
      def <<(permission)
        if any? { |p| p.scoped_resource == permission.scoped_resource }
          raise "permission #{permission.scoped_resource('/')} already exist." 
        else
          super
        end
      end
      alias_method :push, :<<

      def scope(name)
        select { |permission| permission.options[:scope] == name }
      end

      def to_hash
        self.inject({}){|d,v| d.merge v.to_hash}
      end
    end

    class Permission
      attr_reader :resource, :actions, :options
      # === Options
      # [:scope]
      def initialize(resource, actions = [], options = {})
        @resource = resource
        @actions = actions
        @options = options
      end

      def to_hash
        perm = actions.inject({}){|d,v| d.merge(v => "0") }
        unless options.blank?
          perm = perm.merge :options=>options
        end
        { resource =>  perm }
      end

      def scope
        options[:scope]
      end

      # 命名空间下的resource，
      #   如：skyeye_power__bill   默认格式
      #   或：skyeye_power/bill
      def scoped_resource(separator = "__")
        if separator == '/' 
          @slash_scoped_resource ||= [scope, resource].compact.join(separator)
        else
          @underline_scoped_resource ||= [scope, resource].compact.join(separator)
        end
      end
    end
    
  end
end
