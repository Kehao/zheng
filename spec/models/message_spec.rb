require 'spec_helper'

describe Message do
  describe "Validation" do
    let(:message) { build(:message) }

    it "correct message should be valid" do
      message.should be_valid
    end
    it "recipient should be present" do
      message.recipient = nil
      message.should_not be_valid
    end
    it "event should be present" do
      message.event = nil
      message.should_not be_valid
    end
  end

  describe "callback to update recipient unread messages count" do
    it "when create a new message and unread, should update recipient unread messages count" do
      msg = create(:message)
      msg.recipient.reload.unread_messages_count.should == 1
    end
    it "when read an unread message, should update recipient unread messages count" do
      msg = create(:message)
      msg.reading
      msg.recipient.reload.unread_messages_count.should == 0
    end
    it "when read an read message, should not update recipient unread messages count" do
      msg = create(:message)
      msg.reading
      msg.recipient.reload.unread_messages_count.should == 0

      msg.reading
      msg.recipient.reload.unread_messages_count.should == 0
    end
  end
end
