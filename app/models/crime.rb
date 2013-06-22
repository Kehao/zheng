# encoding: utf-8
class Crime < ActiveRecord::Base
  attr_accessible :party_name, 
                  :party_number, 
                  :case_id, 
                  :case_state, 
                  :state,
                  :reg_date,
                  :regist_date, 
                  :apply_money, 
                  :court_name, 
                  :snapshot_at,
                  :orig_url

  belongs_to :party, polymorphic: true, counter_cache: true # Party is Company/Person
  validates_uniqueness_of :case_id, scope: [:party_name, :party_number]

  # === Parameters ===============
  # * value 
  #   is a string or Date instance
  # update filed value into right format
  def reg_date=(value)
    if value.is_a?(String)
      super(value)
      self.regist_date = Date.parse value.split(/年|月|日/).join("-")
    else
      super(value.strftime("%Y-%m-%d"))
      self.regist_date = value 
    end
    reg_date
  end

  STATE_LIST = { 
    other:      0,
    closed:     1,
    processing: 2,
    stopped:    3,
    evaluating: 4,
    onsale:     5,
    deferring:  6,
    auditing:   7,
    cleaning:   8 
  }

  STATE_LIST_CN = {
    other:      "其他",
    closed:     "已结案",
    processing: "执行中",
    stopped:    "中止执行",
    evaluating: "评估中",
    onsale:     "拍卖中",
    deferring:  "暂缓执行",
    auditing:   "司法审计中",
    cleaning:   "资产清理中" 
  }

  include Enumerize
  enumerize :state, in: STATE_LIST

  scope :outstanding, where("crimes.state NOT IN (1, 3)")

  def case_state=(value)
    self.state = STATE_LIST_CN.key(value.to_s.strip) || "other"
    super(value)
  end

  ##================================
  # * category_state of current crime
  def states_other
    ["evaluating", "onsale", "deferring", "auditing", "cleaning", "other"]
  end

  def category_state
    states_other.include?(state) ? "other" : state
  end
  
  # 案件日期到现在是否超过几个月
  #
  # === Example:
  #   crime.exceed?(6) # 是否超过6个月
  #   crime.exceed?(8) # 是否超过8个月
  def exceed?(month)
    return false unless regist_date
    month = month.to_i
    
    Date.today > regist_date.months_since(month)
  end

  ##============================================
  # following is for update crimes snapshots
  def get_snapshot
    path = Snapshot::Court.new(orig_url: self.orig_url, party_number: "#{self.party_type}-#{self.party_id}", case_id: self.id).run
    if path 
      self.snapshot_path = path 
      self.snapshot_at = Time.now
      self.save
    end
  end

  def update_snapshot
    SnapshotWorker.perform_async(self.id)
  end

  ##============================================
  # following is for update party's court status
  attr_reader   :old_object
  before_update :load_old_object
  after_save    :update_party_court_status

  private
  def load_old_object
    @old_object = self.class.find_by_id(self.id)
  end
  
  # 如果【法院信息】发生了更新，那【crime】对应的party状态也需要更新；
  def update_party_court_status
    if old_object
      if old_object.party != self.party
        party && party.update_court_status_with_new_state(self.category_state)
      elsif old_object.category_state != self.category_state
        party && party.update_court_status_through_crimes
      end
    else
      party && party.update_court_status_with_new_state(self.category_state)
    end
  end

end
