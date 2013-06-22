module AssociationUnrepeatAdd
  class NotExistReflection < StandardError; end
  class AssociationAlreadyExist < StandardError; end

  extend ActiveSupport::Concern

  module ClassMethods
    # 定义不重复添加的association collection relation
    #
    # === Parameters
    # * association_names
    #   An association name or an array association names.
    # * options
    # * block
    #   You can give a block to initialize the instance with extra attribute values.
    #   
    # === Options
    # [:uniq_keys]
    #   Specify which attributes to be uniqueness in where clause.
    # 
    # === Example:
    #   class User < ActiveRecord::Base
    #     unrepeat_add :books, uniq_keys: [:name, :isbn]
    #     unrepeat_add [:friends, :teachers]
    #   end
    #
    #   user.add_book(book)
    #   user.add_book(book_id)
    #   user.add_book(book_attrs)
    #   user.add_book(book_attrs, uniq_keys: [:isbn])
    #   user.add_book(book_attrs) { |book| book.isbn = '' }
    #
    #   user.add_friend(friend)
    #   user.add_friend(friend_id)
    #   user.add_friend(friend_attrs)
    #
    #   So it will define add_book, add_friend instance methods and also there
    #   exists add_book!, add_friend! methods which will raise erroe if an association already exist other than only return false.
    def unrepeat_add(association_names, options = {})
      association_names = [association_names].flatten.uniq.map { |name| name.to_sym }
      assert_unrepeat_association_names(association_names)
      association_names.each do |name|
        define_unrepeat_add_association_method(name, options) 
      end
    end
    
    # name is a symbol
    def define_unrepeat_add_association_method(name, options = {})
      singularize_name = name.to_s.singularize
      class_eval <<-EOS
        def add_#{singularize_name}(association_or_id_or_attrs, options = {}, &block)
          if ::ActiveRecord::Base === association_or_id_or_attrs
            instance = association_or_id_or_attrs
            add_association_by_instance(#{name.inspect}, instance, options)
          elsif Hash === association_or_id_or_attrs
            attrs = association_or_id_or_attrs
            options.reverse_merge!(uniq_keys: #{options[:uniq_keys].inspect})
            add_association_by_attrs(#{name.inspect}, attrs, options, &block)
          else
            id = association_or_id_or_attrs
            add_association_by_id(#{name.inspect}, id, options)
          end
        end

        def add_#{singularize_name}!(association_or_id_or_attrs, options = {}, &block)
          add_#{singularize_name}(association_or_id_or_attrs, options.merge!(raise: true), &block)
        end

        alias_method :unrepeat_add_#{singularize_name}, :add_#{singularize_name}
      EOS
    end

    def assert_unrepeat_association_names(association_names)
      unless association_names.all? { |name| reflections.include?(name) }
        raise(NotExistReflection, "reflection name not exists in #{association_names.inspect}.") 
      end
    end
  end

  private
  # Instance methods
  def add_association_by_instance(association_name, instance, options = {})
    if self.send(association_name).exists?(instance)
      options[:raise] ? raise(AssociationAlreadyExist) : false
    else
      self.send(association_name).push(instance)
    end
  end

  def add_association_by_id(association_name, id, options = {})
    klass = self.class.reflections[association_name].klass

    instance = klass.find(id)

    add_association_by_instance(association_name, instance, options)
  end

  def add_association_by_attrs(association_name, attrs = {}, options = {}, &block)
    if options[:uniq_keys].present?
      where_clause = attrs.select { |key| options[:uniq_keys].include?(key.to_sym) }
    else
      where_clause = attrs.dup
    end

    klass = self.class.reflections[association_name].klass
    
    instance = klass.where(where_clause).first

    if instance
      add_association_by_instance(association_name, instance, options)
    else
      instance = self.send(association_name).build(attrs)
      yield instance if block_given?
      self.save
    end

    instance
  end
end

::ActiveRecord::Base.send :include, AssociationUnrepeatAdd
