#encoding: utf-8
require 'spec_helper'

describe CourtAlarm do
  it "should init carriage and carriage[:sent_recipient_ids]" do
    court_alarm = CourtAlarm.new
    court_alarm.carriage.should_not be_nil
    court_alarm.carriage[:sent_recipient_ids].should == []

    court_alarm = CourtAlarm.new(:carriage => {:crime_ids => []})
    court_alarm.carriage[:sent_recipient_ids].should == []
  end

  describe "#notify, send messages to relate users" do
    let(:user)        { create(:user) }
    let(:court_alarm) { create(:court_alarm) }

    before do
      user.companies.push(court_alarm.subject)
    end

    it "record sent users" do
      court_alarm.notify
      court_alarm.sent_recipient_ids.should include(user.id)
    end
    it "have not sent users should recive message" do
      court_alarm.notify
      user.messages.should have(1).item

      msg = user.messages.first
      msg.event.should == court_alarm 
      msg.read.should be_false
    end
    it "have sent users should not repeate recive messsage" do
      court_alarm.notify

      court_alarm.notify
      user.messages.should have(1).item
    end
    it "user recived message should be court alarm message" do
      court_alarm.notify
      msg = user.messages.first
      msg.event_type.should == 'CourtAlarm'
    end
  end
end
