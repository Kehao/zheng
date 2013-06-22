#encoding: utf-8
# === subject
#   company/person
#
# === carriage
#   crime_ids:
#   sent_recipient_ids:
#
class CourtAlarm < Notice
  after_initialize :init_carriage_sent_recipient_ids

  def crime_ids
    carriage[:crime_ids]
  end

  def crimes
    @crimes ||= Crime.where(:id => crime_ids)
  end

  def sent_recipient_ids
    carriage[:sent_recipient_ids]
  end

  def sent_recipients
    @send_recipients ||= User.where(:id => send_recipient_ids)
  end

  def content
  end

  def text
  end

  
  def company
    subject
  end

  def report_to_apollo
    Reporter::Apollo.report_via(self) if report_conditions
  end

  def report_conditions
    self.sent_to_apollo == false &&
    subject.is_a?(Company) && 
    subject.apollo_business && 
    subject.apollo_business.order_status == "loan_after" 
  end

  def today?
    self.created_at > Date.today.beginning_of_day && self.created_at <= Date.today.end_of_day
  end

  def notify
    self.subject.users.each do |user|
      next if sent_recipient_ids.include?(user.id)
      msg = user.messages.create(:event => self)
      self.sent_recipient_ids << user.id unless msg.new_record?
    end

    #report_to_apollo

  ensure
    self.save
  end

  private
  def init_carriage_sent_recipient_ids
    self.carriage ||= {}
    self.carriage[:sent_recipient_ids] ||= []
  end
end
