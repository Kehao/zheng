#encoding: utf-8
require 'net/http'

module Reporter 
  module Apollo
    extend Configurable
    extend Cycle

    configure do |config| 
      #config.request_url = 'http://192.168.1.151:8080/crm/dealSkyEyeRiskWarn.action'
      #config.request_url = 'http://crm.qqw.com.cn/dealSkyEyeRiskWarn.action'
      config.after_ok = lambda do |message|
        message.event.sent_to_apollo = true
        message.event.save
      end
    end

    def self.logger
      Reporter.logger
    end

    class << self
      def report 
        logger.info "=== [begin] ===" * 3 
        yield 
        logger.info "=== [ end ] ===" * 3 + "\n" * 5
      rescue Exception => ex
        logger.error "*** [error] report 出错!"
        logger.error "*** errors: #{ex.message}"
      end

      def find_events_scope
        CourtAlarm.
          joins("inner join skyeye_apollo_apollo_businesses ab").
          where("subject_id = ab.company_id").
          where("ab.custinfoid is not null").
          where(:subject_type=>"Company").
          where(:sent_to_apollo => false).
          where("ab.order_status = 1").
          readonly(false)
      end

      ####
      # => Reporter::Apollo.report_today
      # => Reporter::Apollo.report_daily(which_day)
      def report_from_record(options)
        report do
          find_events_scope.where(
            :created_at=>options[:from_at]..options[:to_at]).find_each do |event|
            report_via(event)
            end
        end
      end

      def report_all_except_today
        report do
          time = Date.today.beginning_of_day
          find_events_scope.where("`notices`.`created_at` < ?",time).find_each do |event|
            report_via(event)
          end
        end
      end

      def report_all
        report do
          find_events_scope.find_each do |event|
            report_via(event)
          end
        end
      end

      def report_via(event)
        message = Message.new(event) 
        if message.valid? 
          post_data(message)
        else
          logger.warn "=== [unvalid] event_id:#{event.id},message:#{message.to_hash} "
        end
      end

      def post_data(message)
        uri = URI(config.request_url)
        res = Net::HTTP.post_form(uri,:data => JSON(message.to_hash))
        case res
        when Net::HTTPOK
          logger.info "=== [ok] event_id:#{message.event.id}"
          self.config.after_ok.call(message)
        else
          logger.warn "=== [fail] event_id:#{message.event.id} res:#{res.code} #{res.body}"
        end
      rescue Exception => ex
        logger.error "*** [error] event_id:#{message.event.id}"
        logger.error "*** errors: #{ex.message}"
      end
    end

    class Message < Reporter::Message
      cattr_accessor :message_items
      self.message_items = %W(customerid warntype warnlevel warnjson warndetail)
      attr_accessor *self.message_items

      WARNLEVEL = 1
      WARNTYPE  = "WI0000075".freeze
      WARNDETAIL_FORMAT = "通过全国法院被执行网查询到%s有被执行人标的%s次的执行信息,执行总金额为%s元,请关注" 

#      def post(uri)
#
#      end

      def initialize(event)
        super(event)
        analyze
      end

      def valid?
        return false if self.customerid.nil?
        return false if self.warnjson.blank?
        true
      end

      def analyze
        apollo_business = event.subject.apollo_business 

        self.customerid = apollo_business.custinfoid if apollo_business 
        self.warntype = WARNTYPE 
        self.warnlevel = WARNLEVEL 

        total_apply_money = 0 
        crime_count = 0 

        self.warnjson =
          event.crimes.inject([]) do |crime_ary,crime|
          crime_count += 1
          total_apply_money += crime.apply_money.to_f
          c = {
            orig_url: Sqider::Gateway.shorten_it(crime.orig_url),
            case_id: crime.case_id,
            case_state: crime.case_state,
            snapshot_path: crime.snapshot_path 
          }
          crime_ary.push c
          end

        self.warndetail = 
          WARNDETAIL_FORMAT % [event.created_at.strftime("%Y-%m-%d"),crime_count,total_apply_money.round(2)]
      end
    end


  end

end
