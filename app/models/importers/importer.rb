#encoding: utf-8
class Importer < ActiveRecord::Base
  include Enumerize
  include ImportMethods

  attr_accessible :status, :file, :name, :error_message
  attr_accessor :parser

  belongs_to :user
  belongs_to :importable, :polymorphic => true

  has_many :importer_exception_temps,dependent: :destroy

  after_commit :schedule_to_import, on: :create

  mount_uploader :file, ImporterUploader

  IMPORT_STATUS = {error: -1, waiting: 0, importing: 1, complete: 2}
  enumerize :status, in: IMPORT_STATUS, default: :waiting

  #前端文件大小限制
  # MAXLINE = 5000

  def parser
    @parser ||= RooExcel.new(self,file.path) 
  end

  def progress_rate
    @progress_rate ||= ProgressRate.new(self,parser.lines_count)
  end

  def import_row_with_pre_valid(row)
    if row_pre_valid?(row)
      import_row(row)
    end
    row_valid?
  end

  def import
    update_attributes(status: "importing")

    progress_rate.start do
      parser.each_row do |row|

        if  import_row_with_pre_valid(row)
          progress_rate.increment_counter
        end

      end
    end

    update_attributes(status: "complete")
  rescue Exception => ex
    logger.error "*** 导入出错!"
    logger.error "*** errors: #{ex.message}"
    update_attributes( status: "error", error_message: ex.message)
  ensure
    send_faye_channel
  end

  def send_faye_channel
    FayeClient.publish("/user-#{user.id}", {:go_to_path => self.faye_go_to_path, :status => :complete})
  end

  def s(v)
    unless v.nil?
      v.to_s.strip
    else
      ""
    end
  end

  def row_pre_validations(row)
    #do nothing or overwrited by subclass
  end

  def row_pre_valid?(row)
    row_pre_validations(row)
    row_valid?
  end

  def row_valid?
    row_exception_msgs.blank? 
  end

  def row_temp(row)
    importer_exception_temps.create(
      :data => row,
      :exception_msg => row_exception_msgs.join(", ")
    )
    @row_exception_msgs = []
  end

  def add_row_exception_msgs(msg)
    row_exception_msgs << msg
  end

  def row_exception_msgs
    @row_exception_msgs ||= []
  end

  def import_row(row)
    raise "method import_row should be overwrite !"
  end

  def faye_go_to_path
    raise "method faye_go_to_path should be overwrite !"
  end

  class << self
    def s(v)
      unless v.nil?
        v.to_s.strip
      else
        ""
      end
    end
  end

  private

  def schedule_to_import
    ImporterWorker.perform_async(self.id)
  end
end


