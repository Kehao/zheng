class ProgressRate
    attr_accessor :total, :counter
    attr_accessor :start_time, :time_cost, :time
    attr_accessor :importer

    def initialize(importer = nil, total = 0)
      @importer = importer
      @started = false
      @total   = total
      @counter = 0
    end

    def start
      record do
        @started = true
        self.start_time = Time.now
      end
      yield 
      stop
    end

    def stop
      record do
        @started = false
      end
    end

    def record_counter(counter)
      record do
        @counter = counter
      end
    end

    def record
      yield
      self.time = Time.now
      if self.importer
        self.importer.process_bar = self.to_json
        self.importer.save
      end
    end

    def increment_counter
      record do
        @counter += 1
      end
      send_faye_channel_for_process_bar
    end

    def send_faye_channel_for_process_bar
      if @counter % 50 == 0
        FayeClient.publish("/user-#{importer.user.id}", {:process_bar => self.to_hash, :importer_id=>importer.id})
      end
    end

    def decrement_counter
      record do
        @counter -= 1
      end
    end

    def cost_time 
      time - start_time
    end

    def to_hash
      { 
        total: total,
        counter: counter,
        cost_time: cost_time,
        rate: self.rate,
        bar: self.bar
      }
    end

    def to_json
      JSON.dump(self.to_hash) 
    end

    def rate
      return 0 if total.zero?
      (counter.to_f/total.to_f).round(2) * 100
    end

    def bar
      "#{self.counter}/#{self.total}"
    end
  end
