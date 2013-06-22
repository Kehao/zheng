#encoding: utf-8
module Reporter 
  class Message
    attr_accessor :event
    def initialize(event)
      @event = event
    end
    
    def to_hash 
      self.class.message_items.inject({}) do |h,item|  
        h[item.intern] = self.send(item) 
        h
      end
    end

    def valid?
      true
    end

    def to_json
      JSON(self.to_hash)
    end

  end
end
