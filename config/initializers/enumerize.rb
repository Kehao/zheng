module Enumerize
  class Attribute
    # Support class enumerize attribute value method 
    #
    # === Example
    #
    #   class User
    #     include Enumerize
    #     enumerize :sex, :in => {:female => 0, :male => 1}
    #   end
    #
    #   -- Before --
    #
    #   User.sex.find_value("female")
    #   User.sex.find_value("female").value
    #    
    #   -- Now --
    #
    #   User.sex.female        # => return female value
    #   User.sex.female.value  # => return 0
    #
    #   User.sex.male          #  => return male value
    #   User.sex.male.value    #  => return 1
    def method_missing(method, *args, &block)
      if values.include?(method.to_s)
        find_value(method.to_s)
      else
        super
      end
    end
  end
end
