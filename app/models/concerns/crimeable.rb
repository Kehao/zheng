module Crimeable
  extend ActiveSupport::Concern
  COURT_STATUS  = { ok: 0, closed: 1, stopped: 2, other: 3, processing: 4 }
  
  included do
    include Enumerize unless included_modules.include?(Enumerize)
    enumerize    :court_status, in: COURT_STATUS, default: :ok

    has_many     :crimes, as: :party
    unrepeat_add :crimes, uniq_keys: [:party_number, :party_name, :case_id]
  end

  module ClassMethods
    def update_all_court_status_through_crimes
      find_each do |c|
        c.update_court_status_through_crimes
      end
    end

    def ok_court_status
      [court_status.ok, court_status.closed, court_status.stopped]
    end

    def warning_court_status
      [court_status.other]
    end

    def closed_or_stoped_or_other_status
      [court_status.other,court_status.closed, court_status.stopped]
    end

    def problem_court_status
      [court_status.processing]
    end

    def with_court_status
      [court_status.closed, court_status.stopped, court_status.other, court_status.processing]
    end

    def ok_court_status_values
      ok_court_status.map(&:value)
    end

    def warning_court_status_values
      warning_court_status.map(&:value)
    end

    def problem_court_status_values
      problem_court_status.map(&:value)
    end

    def closed_or_stoped_or_other_status_values
      closed_or_stoped_or_other_status.map(&:value)
    end

    def with_court_status_values
      with_court_status.map(&:value)
    end

    def select_worst_court_status(court_statuses)
      sort_court_statuses(court_statuses).last
    end

    def select_best_court_status(court_statuses)
      sort_court_statuses(court_statuses).first
    end

    def sort_court_statuses(court_statuses)
      court_statuses = court_statuses.dup.uniq.compact.select { |court_status| COURT_STATUS.include?(court_status.to_sym) }
      court_statuses.sort_by { |court_status| COURT_STATUS[court_status.to_sym] }
    end
  end

  def add_or_update_crime(crime_attrs)
    # 判断企业，法人名字是否与案件的当事人名字一致，如果不一致，直接返回不处理
    return unless self.name.strip == crime_attrs[:party_name].strip
    exist_crime = self.crimes.where(crime_attrs.dup.extract!(:party_name, :party_number, :case_id)).first
    if exist_crime
      exist_crime.update_attributes(crime_attrs)
    else
      self.add_crime(crime_attrs)
    end
  end

  def update_court_status_through_crimes
    category_states = self.crimes(reload: true).map(&:category_state).uniq
    
    if category_states.include?('processing')
      self.court_status = 'processing'
    elsif category_states.include?('other')
      self.court_status = 'other'
    elsif category_states.include?('stopped')
      self.court_status = 'stopped'
    elsif category_states.include?('closed')
      self.court_status = 'closed'
    else
      self.court_status = 'ok'
    end

    self.save
  end

  def update_court_status_with_new_state(state)
    self.court_status = self.class.select_worst_court_status([court_status, state])
    self.save
  end
end
