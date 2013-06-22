#encoding: utf-8
class Can
  TRUE_FLAGS  = ["1", 1, true  ]
  FALSE_FLAGS = ["0", 0, false ]

  delegate :[], :[]=, :inspect, :to_s, :each, :blank?, to: :abilities

  attr_reader :abilities, :subcan

  # === Parameters
  # * abilities
  #   资源权限操作hash, 如：
  #     {
  #       crime: {read: true},
  #       cert:  {read: true}
  #       skyeye_power__bill: {read: true}
  #     }
  #   如果是插件里的资源 以 __ 区分命名空间和资源
  # * subcan
  #   是否是子can，默认为false, subcan代表的是can里一个资源的权限操作，如crime: {read: true}
  def initialize(abilities = {}, subcan = false)
    @abilities = abilities.symbolize_keys()
    @subcan = subcan
  end

  # == Example
  #  can.crime.view
  #  can.crime.edit
  #  can.cert.view
  #  can.cert.edit
  #
  #  Delay instantiate until to use
  def method_missing(name, *args, &block)
    if abilities.key?(name)
      if TRUE_FLAGS.include?(abilities[name])
        true
      elsif FALSE_FLAGS.include?(abilities[name])
        false
      else
        if self.class === abilities[name]
          abilities[name]
        else
          abilities[name] = self.class.new(abilities[name], true) # true for subcan
        end
      end
    else
      if subcan
        false
      else
        # If not exist a key(resource) then mock a key with a blank can instance, so
        # we can call chain like this: <tt>can.resource_name.read  # => false</tt>
        abilities[name] = self.class.new({}, true)
      end
    end
  end

end
