#encoding: utf-8
class ImporterExceptionTemp < ActiveRecord::Base
  attr_accessible :data,:exception_msg,:status
  serialize  :data, Array
  belongs_to :importer

  def status_text
     ["不可导入","可导入"][self.status]
  end

  def data=(str)
    if str.is_a?(Array)
      super(str)
    else
      #TODO
      super(eval(str)) 
    end
  end

end
